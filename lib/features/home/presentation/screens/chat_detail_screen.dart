import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';
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

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUid = ref.read(currentUserProvider)?.uid;
    if (currentUid == null) return;

    final message = MessageModel(
      id: const Uuid().v4(),
      senderId: currentUid,
      text: text,
      createdAt: DateTime.now(),
    );

    await ref.read(messageRepositoryProvider).sendMessage(widget.chatId, message);
    _messageController.clear();
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
                  error: (_, __) => const SizedBox.shrink(),
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
          IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send, color: Colors.black)),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(0),
          ),
        ),
        child: Text(message.text, style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 14)),
      ),
    );
  }
}
