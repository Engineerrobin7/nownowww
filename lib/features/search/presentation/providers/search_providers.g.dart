// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchRepositoryHash() => r'c7592ca7cc3d16fd785421749fa7dc1757ea258d';

/// See also [searchRepository].
@ProviderFor(searchRepository)
final searchRepositoryProvider =
    AutoDisposeProvider<ISearchRepository>.internal(
  searchRepository,
  name: r'searchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchRepositoryRef = AutoDisposeProviderRef<ISearchRepository>;
String _$popularUsersHash() => r'cc068acf3965e955c52c1bc2fdef8fde4674ecfc';

/// See also [popularUsers].
@ProviderFor(popularUsers)
final popularUsersProvider =
    AutoDisposeFutureProvider<List<UserModel>>.internal(
  popularUsers,
  name: r'popularUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$popularUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PopularUsersRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$searchUsersResultHash() => r'16aaf8cd1f205670cdda646b3ae15555c8e4db60';

/// See also [searchUsersResult].
@ProviderFor(searchUsersResult)
final searchUsersResultProvider =
    AutoDisposeFutureProvider<List<UserModel>>.internal(
  searchUsersResult,
  name: r'searchUsersResultProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchUsersResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchUsersResultRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$searchPostsResultHash() => r'10f4219293acfb3bd01f0a4481924ec18820e524';

/// See also [searchPostsResult].
@ProviderFor(searchPostsResult)
final searchPostsResultProvider =
    AutoDisposeFutureProvider<List<PostModel>>.internal(
  searchPostsResult,
  name: r'searchPostsResultProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchPostsResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchPostsResultRef = AutoDisposeFutureProviderRef<List<PostModel>>;
String _$searchTopicsResultHash() =>
    r'859dde4b23459458d1598825be785fcae820d82b';

/// See also [searchTopicsResult].
@ProviderFor(searchTopicsResult)
final searchTopicsResultProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  searchTopicsResult,
  name: r'searchTopicsResultProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchTopicsResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchTopicsResultRef = AutoDisposeFutureProviderRef<List<String>>;
String _$searchQueryHash() => r'32848c18dd36b350439a45fa6338bf2df6758978';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
