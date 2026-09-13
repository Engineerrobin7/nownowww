import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nownowww/features/posts/presentation/widgets/post_card.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/home/presentation/providers/message_providers.dart';
import 'package:nownowww/features/profile/presentation/widgets/person_item.dart';
import '../providers/search_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _searchController = TextEditingController(text: widget.initialQuery);
    
    if (widget.initialQuery != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchQueryProvider.notifier).updateQuery(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
        title: const Text('Search', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search needs, thoughts, people...',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              ref.read(searchQueryProvider.notifier).updateQuery(value.trim());
                            },
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(searchQueryProvider.notifier).updateQuery('');
                            },
                          ),
                        const Icon(Icons.tune, color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
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
              Tab(text: '  Needs  '),
              Tab(text: '  Think  '),
              Tab(text: '  People  '),
              Tab(text: '  Topics  '),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AllResultsView(),
                _PostResultsView(filterType: 'need'),
                _PostResultsView(filterType: 'think'),
                _UserResultsView(),
                _TopicResultsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllResultsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    if (query.isEmpty) {
      return _TrendingAndRecent();
    }

    return ListView(
      children: [
        _UserResultsView(shrinkWrap: true),
        const Divider(),
        _PostResultsView(shrinkWrap: true),
      ],
    );
  }
}

class _TrendingAndRecent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularUsersAsync = ref.watch(popularUsersProvider);
    final trendingTopicsAsync = ref.watch(searchTopicsResultProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _SectionHeader(title: 'Trending Now', onSeeAll: () {}),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: trendingTopicsAsync.when(
            data: (topics) {
              if (topics.isEmpty) {
                 return ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _TrendingCard(tag: '#Internship', posts: '1.2K posts'),
                    _TrendingCard(tag: '#Hiring', posts: '987 posts'),
                    _TrendingCard(tag: '#Freelance', posts: '876 posts'),
                  ],
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => ref.read(searchQueryProvider.notifier).updateQuery(topics[index]),
                  child: _TrendingCard(tag: '#${topics[index]}', posts: 'Recently trending'),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
        const SizedBox(height: 32),
        _SectionHeader(title: 'Popular People', onSeeAll: () {}),
        popularUsersAsync.when(
          data: (users) {
            if (users.isEmpty) return const Text('No popular users found.');
            return Column(
              children: users.map((user) => PersonItem(user: user)).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
          error: (e, _) => Text('Error: $e'),
        ),
        const SizedBox(height: 32),
        _SectionHeader(title: 'Recent Searches', onSeeAll: () {}, seeAllText: 'Clear all'),
        const _RecentSearchItem(text: 'digital marketing job'),
        const _RecentSearchItem(text: 'graphic designer'),
        const _RecentSearchItem(text: 'content writer'),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _UserResultsView extends ConsumerWidget {
  final bool shrinkWrap;
  const _UserResultsView({this.shrinkWrap = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(searchUsersResultProvider);
    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) return const SizedBox.shrink();
        return ListView.builder(
          shrinkWrap: shrinkWrap,
          physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return InkWell(
              onTap: () async {
                final currentUid = ref.read(currentUserProvider)?.uid;
                if (currentUid == null) return;
                final chatId = await ref.read(messageRepositoryProvider).getOrCreateChat(currentUid, user.uid);
                if (context.mounted) {
                  context.push('/chat-detail/$chatId', extra: user);
                }
              },
              child: PersonItem(user: user),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _PostResultsView extends ConsumerWidget {
  final bool shrinkWrap;
  final String? filterType;
  const _PostResultsView({this.shrinkWrap = false, this.filterType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(searchPostsResultProvider);
    return postsAsync.when(
      data: (posts) {
        var filteredPosts = posts;
        if (filterType != null) {
          filteredPosts = posts.where((p) => p.type.name == filterType).toList();
        }
        if (filteredPosts.isEmpty) return const Center(child: Text('No posts found.'));
        return ListView.builder(
          shrinkWrap: shrinkWrap,
          physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) => PostCard(post: filteredPosts[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _TopicResultsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsAsync = ref.watch(searchTopicsResultProvider);
    return topicsAsync.when(
      data: (topics) {
        if (topics.isEmpty) return const Center(child: Text('No topics found.'));
        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.tag),
            title: Text(topics[index]),
            onTap: () {
               ref.read(searchQueryProvider.notifier).updateQuery(topics[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final String seeAllText;

  const _SectionHeader({required this.title, required this.onSeeAll, this.seeAllText = 'See all'});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        TextButton(onPressed: onSeeAll, child: Text(seeAllText, style: const TextStyle(color: Colors.grey, fontSize: 12))),
      ],
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final String tag;
  final String posts;

  const _TrendingCard({required this.tag, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.purple.withAlpha(10), shape: BoxShape.circle),
            child: const Icon(Icons.tag, size: 14, color: Colors.purple),
          ),
          const Spacer(),
          Text(tag, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(posts, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
        ],
      ),
    );
  }
}

class _RecentSearchItem extends StatelessWidget {
  final String text;

  const _RecentSearchItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 14))),
          const Icon(Icons.close, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
