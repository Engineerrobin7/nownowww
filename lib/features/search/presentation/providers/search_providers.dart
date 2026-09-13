import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/firestore_search_repository.dart';
import '../../domain/repositories/search_repository.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';

import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';

part 'search_providers.g.dart';

@riverpod
ISearchRepository searchRepository(SearchRepositoryRef ref) {
  return FirestoreSearchRepository();
}

@riverpod
Future<List<UserModel>> popularUsers(PopularUsersRef ref) {
  return ref.watch(userRepositoryProvider).getPopularUsers();
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

@riverpod
Future<List<UserModel>> searchUsersResult(SearchUsersResultRef ref) {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(searchRepositoryProvider).searchUsers(query);
}

@riverpod
Future<List<PostModel>> searchPostsResult(SearchPostsResultRef ref) {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(searchRepositoryProvider).searchPosts(query);
}

@riverpod
Future<List<String>> searchTopicsResult(SearchTopicsResultRef ref) {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(searchRepositoryProvider).searchTopics(query);
}
