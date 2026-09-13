import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/post_model.dart';
import '../providers/post_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'feed_controller.g.dart';

@riverpod
class FeedController extends _$FeedController {
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  PostType? _currentType;

  @override
  Future<List<PostModel>> build([PostType? type]) async {
    _currentType = type;
    _lastDoc = null;
    _hasMore = true;
    return _fetchPosts();
  }

  Future<List<PostModel>> _fetchPosts() async {
    final result = await ref.read(postRepositoryProvider).fetchFeed(
      limit: 20,
      lastDoc: _lastDoc,
      type: _currentType,
    );

    _lastDoc = result.lastDoc;
    _hasMore = result.hasMore;
    
    return result.posts;
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !_hasMore) return;

    final currentPosts = state.value ?? [];
    
    final newPosts = await _fetchPosts();
    state = AsyncValue.data([...currentPosts, ...newPosts]);
  }
  
  Future<void> refresh() async {
    _lastDoc = null;
    _hasMore = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPosts());
  }
}
