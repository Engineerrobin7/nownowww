import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/features/notifications/presentation/providers/notification_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.black), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.black,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          indicator: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: '  All  '),
            Tab(text: '  Comments  '),
            Tab(text: '  Replies  '),
            Tab(text: '  Mentions  '),
            Tab(text: '  System  '),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotificationsListView(),
          const Center(child: Text('Comments Notifications')),
          const Center(child: Text('Replies Notifications')),
          const Center(child: Text('Mentions Notifications')),
          const Center(child: Text('System Notifications')),
        ],
      ),
    );
  }
}

class _NotificationsListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: const [
            Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            SizedBox(height: 12),
            _NotificationTile(
              name: 'Priya Malhotra',
              action: 'commented on your post.',
              time: '58m ago',
              icon: Icons.chat_bubble_outline,
              iconColor: Colors.green,
            ),
            _NotificationTile(
              name: 'Kabir Verma',
              action: 'replied to your comment.',
              time: '1h ago',
              icon: Icons.reply_outlined,
              iconColor: Colors.blue,
            ),
            _NotificationTile(
              name: 'Arjun Mehta',
              action: 'mentioned you in a comment.',
              time: '2h ago',
              icon: Icons.alternate_email,
              iconColor: Colors.purple,
            ),
            SizedBox(height: 24),
            Text('Yesterday', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            SizedBox(height: 12),
            _NotificationTile(
              name: 'Rohit Sharma',
              action: 'commented on your post.',
              time: 'Yesterday',
              icon: Icons.chat_bubble_outline,
              iconColor: Colors.green,
            ),
            SizedBox(height: 24),
            Text('Earlier', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            SizedBox(height: 12),
            _NotificationTile(
              name: 'Welcome to NOWNOWWW!',
              action: 'Thanks for joining our community.',
              time: '2d ago',
              icon: Icons.notifications_none_outlined,
              iconColor: Colors.orange,
              isSystem: true,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String name;
  final String action;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isSystem;

  const _NotificationTile({
    required this.name,
    required this.action,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isSystem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withAlpha(10), shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' $action', style: TextStyle(color: isSystem ? Colors.grey.shade600 : Colors.green.shade700)),
                    ],
                  ),
                ),
                Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
