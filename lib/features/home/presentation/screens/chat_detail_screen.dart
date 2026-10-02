import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';
import 'package:nownowww/shared/presentation/providers/storage_providers.dart';
import 'package:nownowww/shared/widgets/presence_avatar.dart';
import '../providers/message_providers.dart';
import '../../domain/models/message_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;
  final UserModel otherUser;

  const ChatDetailScreen({super.key, required this.chatId, required this.otherUser});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _messageController = TextEditingController();
  Timer? _typingTimer;
  File? _selectedImage;
  bool _isUploadingImage = false;

  @override
  void dispose() {
    _messageController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    final currentUid = ref.read(currentUserProvider)?.uid;
    if (currentUid == null) return;

    _typingTimer?.cancel();
    ref.read(messageRepositoryProvider).setTypingStatus(widget.chatId, currentUid, true);

    _typingTimer = Timer(const Duration(seconds: 2), () {
      ref.read(messageRepositoryProvider).setTypingStatus(widget.chatId, currentUid, false);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    final currentUid = ref.read(currentUserProvider)?.uid;
    if (currentUid == null) return;

    setState(() => _isUploadingImage = true);

    String? imageUrl;
    if (_selectedImage != null) {
      try {
        imageUrl = await ref
            .read(storageRepositoryProvider)
            .uploadImage(file: _selectedImage!, path: 'chat_images');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
        }
      }
    }

    final message = MessageModel(
      id: const Uuid().v4(),
      senderId: currentUid,
      text: text,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );

    await ref.read(messageRepositoryProvider).sendMessage(widget.chatId, message);
    _messageController.clear();
    if (mounted) {
      setState(() {
        _selectedImage = null;
        _isUploadingImage = false;
      });
    }
    ref.read(messageRepositoryProvider).setTypingStatus(widget.chatId, currentUid, false);
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final chatsAsync = ref.watch(userChatsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            Hero(
              tag: 'avatar_${widget.otherUser.uid}',
              child: PresenceAvatar(
                photoUrl: widget.otherUser.photoUrl,
                isOnline: widget.otherUser.isOnline,
                radius: 16,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUser.displayName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                chatsAsync.when(
                  data: (chats) {
                    final chat = chats.firstWhere((c) => c.id == widget.chatId);
                    final isTyping = chat.typingStatus[widget.otherUser.uid] ?? false;
                    return isTyping 
                      ? const Text('typing...', style: TextStyle(color: Colors.purple, fontSize: 10, fontStyle: FontStyle.italic))
                      : Text(widget.otherUser.isOnline ? 'Online' : 'Offline', style: TextStyle(color: Colors.grey.shade500, fontSize: 10));
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == ref.read(currentUserProvider)?.uid;
                    return _MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          if (_selectedImage != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_selectedImage!, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  const Text('Image attached', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => setState(() => _selectedImage = null),
                  ),
                ],
              ),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12, top: 12, left: 16, right: 16),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5))),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image_outlined, color: Colors.black),
            onPressed: _pickImage,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: _messageController,
                onChanged: _onTextChanged,
                decoration: const InputDecoration(hintText: 'Message...', border: InputBorder.none, isDense: true),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isUploadingImage ? null : _sendMessage,
            icon: _isUploadingImage
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : const Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null && message.imageUrl!.isNotEmpty) ...[
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog.fullscreen(
                      backgroundColor: Colors.black,
                      child: Stack(
                        children: [
                          Center(child: InteractiveViewer(child: CachedNetworkImage(imageUrl: message.imageUrl!))),
                          Positioned(
                            top: 40,
                            right: 20,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 28),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: message.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ),
                ),
              ),
              if (message.text.isNotEmpty) const SizedBox(height: 8),
            ],
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
