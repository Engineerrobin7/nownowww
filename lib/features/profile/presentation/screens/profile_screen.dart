import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nownowww/features/posts/presentation/providers/post_providers.dart';
import 'package:nownowww/features/posts/presentation/widgets/post_card.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? uid;

  const ProfileScreen({super.key, this.uid});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.uid != null 
        ? ref.watch(userProfileProvider(widget.uid!)).valueOrNull
        : ref.watch(currentUserProfileProvider).valueOrNull;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black)));
    }

    final postsAsync = ref.watch(userPostsProvider(profile.uid));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.ios_share, color: Colors.black), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileProvider(profile.uid));
          ref.invalidate(userPostsProvider(profile.uid));
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  children: [
                    _buildProfileHeader(profile),
                    const SizedBox(height: 24),
                    _buildStatsRow(profile),
                    const SizedBox(height: 24),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'Comments'),
                        Tab(text: 'Activity'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('My Recent Posts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(color: Colors.grey, fontSize: 12))),
                        ],
                      ),
                    ),
                    postsAsync.when(
                      data: (posts) {
                        if (posts.isEmpty) {
                          return const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No posts yet.')));
                        }
                        return Column(
                          children: posts.map((post) => PostCard(post: post)).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.uid == null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/edit-profile', extra: profile),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'avatar_${profile.uid}',
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: profile.photoUrl != null ? NetworkImage(profile.photoUrl!) : null,
                  child: profile.photoUrl == null ? const Icon(Icons.person, size: 45, color: Colors.grey) : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.edit, size: 14, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('@${profile.username}', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Text(profile.bio ?? 'No bio yet.', style: const TextStyle(fontSize: 13, height: 1.3)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Joined May 2024', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(dynamic profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('${profile.needsCount}', 'Needs', Colors.green),
          _buildStatItem('${profile.thoughtsCount}', 'Thoughts', Colors.purple),
          _buildStatItem('${profile.commentsCount}', 'Comments', Colors.blue),
          InkWell(
            onTap: () => context.push('/user-list', extra: {
              'title': 'Following',
              'uids': profile.following,
            }),
            child: _buildStatItem('${profile.followingCount}', 'Following', Colors.orange),
          ),
          InkWell(
            onTap: () => context.push('/user-list', extra: {
              'title': 'Followers',
              'uids': profile.followers,
            }),
            child: _buildStatItem('${profile.followersCount}', 'Followers', Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color color, {String? subLabel}) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        if (subLabel != null) Text(subLabel, style: const TextStyle(fontSize: 8, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      ],
    );
  }
}
