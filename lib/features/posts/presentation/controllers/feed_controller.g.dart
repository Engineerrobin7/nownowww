// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedControllerHash() => r'dd69a4cdcb609c9ff57406eaa1599ebd2608b110';

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

abstract class _$FeedController
    extends BuildlessAutoDisposeAsyncNotifier<List<PostModel>> {
  late final PostType? type;

  FutureOr<List<PostModel>> build([
    PostType? type,
  ]);
}

/// See also [FeedController].
@ProviderFor(FeedController)
const feedControllerProvider = FeedControllerFamily();

/// See also [FeedController].
class FeedControllerFamily extends Family<AsyncValue<List<PostModel>>> {
  /// See also [FeedController].
  const FeedControllerFamily();

  /// See also [FeedController].
  FeedControllerProvider call([
    PostType? type,
  ]) {
    return FeedControllerProvider(
      type,
    );
  }

  @override
  FeedControllerProvider getProviderOverride(
    covariant FeedControllerProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'feedControllerProvider';
}

/// See also [FeedController].
class FeedControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FeedController, List<PostModel>> {
  /// See also [FeedController].
  FeedControllerProvider([
    PostType? type,
  ]) : this._internal(
          () => FeedController()..type = type,
          from: feedControllerProvider,
          name: r'feedControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feedControllerHash,
          dependencies: FeedControllerFamily._dependencies,
          allTransitiveDependencies:
              FeedControllerFamily._allTransitiveDependencies,
          type: type,
        );

  FeedControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final PostType? type;

  @override
  FutureOr<List<PostModel>> runNotifierBuild(
    covariant FeedController notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(FeedController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeedControllerProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FeedController, List<PostModel>>
      createElement() {
    return _FeedControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedControllerProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FeedControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<PostModel>> {
  /// The parameter `type` of this provider.
  PostType? get type;
}

class _FeedControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FeedController,
        List<PostModel>> with FeedControllerRef {
  _FeedControllerProviderElement(super.provider);

  @override
  PostType? get type => (origin as FeedControllerProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
