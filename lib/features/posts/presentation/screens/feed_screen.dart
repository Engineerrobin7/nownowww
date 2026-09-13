import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nownowww/shared/widgets/post_shimmer.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';
import '../controllers/feed_controller.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Get the current controller for the active tab
      _getControllerForTab(_tabController.index).fetchMore();
    }
  }

  dynamic _getControllerForTab(int index) {
    switch (index) {
      case 1: return ref.read(feedControllerProvider(PostType.need).notifier);
      case 2: return ref.read(feedControllerProvider(PostType.think).notifier);
      default: return ref.read(feedControllerProvider(null).notifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'NOWNOWWW',
          style: GoogleFonts.bebasNeue(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.mail_outline, color: Colors.black),
            onPressed: () => context.push('/messages'),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  child: const Text('3', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          indicatorWeight: 2,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'All Posts'),
            Tab(text: 'Need'),
            Tab(text: 'Think'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PostList(scrollController: _scrollController),
          _PostList(scrollController: _scrollController, type: PostType.need),
          _PostList(scrollController: _scrollController, type: PostType.think),
        ],
      ),
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: FloatingActionButton(
          onPressed: () => context.push('/create-post'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_outlined, size: 20),
              const Text('Create Post', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostList extends ConsumerWidget {
  final ScrollController scrollController;
  final PostType? type;

  const _PostList({required this.scrollController, this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedControllerProvider(type));

    return postsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('No posts yet.'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(feedControllerProvider(type).notifier).refresh(),
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index < posts.length) {
                return PostCard(post: posts[index]);
              } else {
                return const PostShimmer();
              }
            },
          ),
        );
      },
      loading: () => ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const PostShimmer(),
      ),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
