import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';
import 'package:nownowww/shared/presentation/providers/storage_providers.dart';
import '../providers/post_providers.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final PostType initialType;

  const CreatePostScreen({
    super.key,
    this.initialType = PostType.think,
  });

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  late PostType _selectedType;
  final _contentController = TextEditingController();
  bool _isLoading = false;
  bool _isAnonymous = false;

  File? _selectedImage;
  bool _showPollCreator = false;
  final List<TextEditingController> _pollControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _contentController.dispose();
    for (final c in _pollControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _addPollOption() {
    if (_pollControllers.length < 4) {
      setState(() {
        _pollControllers.add(TextEditingController());
      });
    }
  }

  Future<void> _submitPost() async {
    final contentText = _contentController.text.trim();
    if (contentText.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final userProfile = ref.read(currentUserProfileProvider).valueOrNull;
      if (userProfile == null) return;

      String? uploadedImageUrl;
      if (_selectedImage != null) {
        uploadedImageUrl = await ref
            .read(storageRepositoryProvider)
            .uploadImage(file: _selectedImage!, path: 'posts');
      }

      List<String>? pollOptions;
      if (_showPollCreator) {
        final options = _pollControllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList();
        if (options.length >= 2) {
          pollOptions = options;
        }
      }

      final post = PostModel(
        id: const Uuid().v4(),
        uid: userProfile.uid,
        authorName: userProfile.displayName,
        authorUsername: userProfile.username,
        authorPhotoUrl: userProfile.photoUrl,
        content: contentText,
        type: _selectedType,
        isAnonymous: _isAnonymous,
        imageUrl: uploadedImageUrl,
        pollOptions: pollOptions,
        createdAt: DateTime.now(),
      );

      await ref.read(postRepositoryProvider).createPost(post);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('Create Post', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _TypeSelector(
                          label: 'Need',
                          description: 'What do you need right now?',
                          icon: Icons.help_outline,
                          isSelected: _selectedType == PostType.need,
                          color: Colors.green,
                          onTap: () => setState(() => _selectedType = PostType.need),
                        ),
                        const SizedBox(width: 16),
                        _TypeSelector(
                          label: 'Think',
                          description: 'What are you thinking right now?',
                          icon: Icons.chat_bubble_outline,
                          isSelected: _selectedType == PostType.think,
                          color: Colors.purple,
                          onTap: () => setState(() => _selectedType = PostType.think),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isAnonymous ? Colors.black.withAlpha(8) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _isAnonymous ? Colors.black : Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isAnonymous ? Icons.visibility_off : Icons.visibility_outlined,
                            size: 20,
                            color: _isAnonymous ? Colors.black : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Post Anonymously', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                Text(
                                  _isAnonymous ? 'Your name and photo will be hidden.' : 'Your profile will be attached to this post.',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: _isAnonymous,
                            onChanged: (val) => setState(() => _isAnonymous = val),
                            activeTrackColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Write your post', style: TextStyle(fontWeight: FontWeight.bold)),
                        ValueListenableBuilder(
                          valueListenable: _contentController,
                          builder: (context, value, _) {
                            return Text(
                              '${value.text.length}/500',
                              style: TextStyle(fontSize: 12, color: value.text.length > 500 ? Colors.red : Colors.grey),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _contentController,
                            maxLines: 5,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: _selectedType == PostType.need 
                                ? 'Share what you need right now...' 
                                : 'Share what you\'re thinking right now...',
                              border: InputBorder.none,
                            ),
                          ),
                          if (_selectedImage != null) ...[
                            const SizedBox(height: 12),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_selectedImage!, height: 160, width: double.infinity, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedImage = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.image_outlined, color: Colors.black),
                                onPressed: _pickImage,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.poll_outlined,
                                  color: _showPollCreator ? Colors.black : Colors.grey,
                                ),
                                onPressed: () => setState(() => _showPollCreator = !_showPollCreator),
                              ),
                              const Spacer(),
                              _QuickActionBtn(
                                label: '@',
                                onTap: () {
                                  _contentController.text += '@';
                                  _contentController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: _contentController.text.length),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _QuickActionBtn(
                                label: '#',
                                onTap: () {
                                  _contentController.text += '#';
                                  _contentController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: _contentController.text.length),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_showPollCreator) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Add Poll Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                  onPressed: () => setState(() => _showPollCreator = false),
                                ),
                              ],
                            ),
                            ...List.generate(_pollControllers.length, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextField(
                                  controller: _pollControllers[i],
                                  decoration: InputDecoration(
                                    hintText: 'Option ${i + 1}',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade200),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            if (_pollControllers.length < 4)
                              TextButton.icon(
                                onPressed: _addPollOption,
                                icon: const Icon(Icons.add, size: 16, color: Colors.black),
                                label: const Text('Add Option', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeSelector({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(10) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey, size: 28),
              const SizedBox(height: 12),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? color : Colors.black)),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickActionBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
