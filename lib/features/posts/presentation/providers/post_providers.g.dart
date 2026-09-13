// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postRepositoryHash() => r'6b63e28f7a79458b9d00db79155de9684ae10fb6';

/// See also [postRepository].
@ProviderFor(postRepository)
final postRepositoryProvider = AutoDisposeProvider<IPostRepository>.internal(
  postRepository,
  name: r'postRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PostRepositoryRef = AutoDisposeProviderRef<IPostRepository>;
String _$userPostsHash() => r'b55925ab433d2ce0c4057c1a59d88c77a8cea6ca';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userPosts].
@ProviderFor(userPosts)
const userPostsProvider = UserPostsFamily();

/// See also [userPosts].
class UserPostsFamily extends Family<AsyncValue<List<PostModel>>> {
  /// See also [userPosts].
  const UserPostsFamily();

  /// See also [userPosts].
  UserPostsProvider call(
    String uid,
  ) {
    return UserPostsProvider(
      uid,
    );
  }

  @override
  UserPostsProvider getProviderOverride(
    covariant UserPostsProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userPostsProvider';
}

/// See also [userPosts].
class UserPostsProvider extends AutoDisposeStreamProvider<List<PostModel>> {
  /// See also [userPosts].
  UserPostsProvider(
    String uid,
  ) : this._internal(
          (ref) => userPosts(
            ref as UserPostsRef,
            uid,
          ),
          from: userPostsProvider,
          name: r'userPostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostsHash,
          dependencies: UserPostsFamily._dependencies,
          allTransitiveDependencies: UserPostsFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<List<PostModel>> Function(UserPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserPostsProvider._internal(
        (ref) => create(ref as UserPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PostModel>> createElement() {
    return _UserPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostsProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserPostsRef on AutoDisposeStreamProviderRef<List<PostModel>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserPostsProviderElement
    extends AutoDisposeStreamProviderElement<List<PostModel>>
    with UserPostsRef {
  _UserPostsProviderElement(super.provider);

  @override
  String get uid => (origin as UserPostsProvider).uid;
}

String _$getPostHash() => r'faf9da6f038ea3b232ec3189b63823f689a1ae40';

/// See also [getPost].
@ProviderFor(getPost)
const getPostProvider = GetPostFamily();

/// See also [getPost].
class GetPostFamily extends Family<AsyncValue<PostModel?>> {
  /// See also [getPost].
  const GetPostFamily();

  /// See also [getPost].
  GetPostProvider call(
    String postId,
  ) {
    return GetPostProvider(
      postId,
    );
  }

  @override
  GetPostProvider getProviderOverride(
    covariant GetPostProvider provider,
  ) {
    return call(
      provider.postId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getPostProvider';
}

/// See also [getPost].
class GetPostProvider extends AutoDisposeFutureProvider<PostModel?> {
  /// See also [getPost].
  GetPostProvider(
    String postId,
  ) : this._internal(
          (ref) => getPost(
            ref as GetPostRef,
            postId,
          ),
          from: getPostProvider,
          name: r'getPostProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPostHash,
          dependencies: GetPostFamily._dependencies,
          allTransitiveDependencies: GetPostFamily._allTransitiveDependencies,
          postId: postId,
        );

  GetPostProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<PostModel?> Function(GetPostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPostProvider._internal(
        (ref) => create(ref as GetPostRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PostModel?> createElement() {
    return _GetPostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPostProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPostRef on AutoDisposeFutureProviderRef<PostModel?> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _GetPostProviderElement
    extends AutoDisposeFutureProviderElement<PostModel?> with GetPostRef {
  _GetPostProviderElement(super.provider);

  @override
  String get postId => (origin as GetPostProvider).postId;
}

String _$currentUserLikesHash() => r'7f2e14990c5d6d78c7b85bc245fe20aaec639546';

/// See also [currentUserLikes].
@ProviderFor(currentUserLikes)
final currentUserLikesProvider =
    AutoDisposeStreamProvider<Set<String>>.internal(
  currentUserLikes,
  name: r'currentUserLikesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserLikesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserLikesRef = AutoDisposeStreamProviderRef<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
