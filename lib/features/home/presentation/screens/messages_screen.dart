import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/features/home/presentation/providers/message_providers.dart';
import 'package:nownowww/features/home/domain/models/chat_model.dart';
import 'package:nownowww/shared/widgets/presence_avatar.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(userChatsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Messages', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.edit_note_outlined, color: Colors.black, size: 28), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search messages...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2))]),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  const Tab(text: 'Inbox'),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Requests'),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                          child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(userChatsProvider);
                  },
                  child: chatsAsync.when(
                    data: (chats) {
                      if (chats.isEmpty) return const Center(child: Text('No messages yet.'));
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: chats.length,
                        itemBuilder: (context, index) => _ChatTile(chat: chats[index]),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
                ),
                const Center(child: Text('Message Requests')),
              ],
            ),
          ),
          _buildSecurityBanner(),
        ],
      ),
    );
  }

  Widget _buildSecurityBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withAlpha(5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withAlpha(10)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.shield_outlined, color: Colors.purple, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your messages are secure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('We use end-to-end encryption to keep your conversations private.', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

class _ChatTile extends ConsumerWidget {
  final ChatModel chat;
  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = ref.watch(currentUserProvider)?.uid;
    if (currentUid == null) return const SizedBox.shrink();
    
    final otherUid = chat.participantIds.firstWhere((id) => id != currentUid, orElse: () => '');
    if (otherUid.isEmpty) return const SizedBox.shrink();
    
    final otherUserAsync = ref.watch(userProfileProvider(otherUid));

    return otherUserAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        final unreadCount = chat.unreadCounts[currentUid] ?? 0;
        final isTyping = chat.typingStatus[otherUid] ?? false;
        
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Hero(
            tag: 'avatar_${user.uid}',
            child: PresenceAvatar(
              photoUrl: user.photoUrl,
              isOnline: user.isOnline,
              radius: 24,
            ),
          ),
          title: Row(
            children: [
              Expanded(child: Text(user.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              const Text('9:40 AM', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  isTyping ? 'typing...' : chat.lastMessage, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: TextStyle(
                    color: isTyping ? Colors.purple : (unreadCount > 0 ? Colors.black87 : Colors.grey.shade600), 
                    fontSize: 13,
                    fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
              if (unreadCount > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                  child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          onTap: () {
            context.push('/chat-detail/${chat.id}', extra: user);
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
