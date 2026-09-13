// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$blockRepositoryHash() => r'9a622195f55a3f58cbeaa363e6f135e3c0bca2b5';

/// See also [blockRepository].
@ProviderFor(blockRepository)
final blockRepositoryProvider = AutoDisposeProvider<IBlockRepository>.internal(
  blockRepository,
  name: r'blockRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blockRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BlockRepositoryRef = AutoDisposeProviderRef<IBlockRepository>;
String _$blockedUsersHash() => r'41a8385c60461d569ebc9e8d895e27b0cdf64c49';

/// See also [blockedUsers].
@ProviderFor(blockedUsers)
final blockedUsersProvider = AutoDisposeStreamProvider<List<String>>.internal(
  blockedUsers,
  name: r'blockedUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$blockedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BlockedUsersRef = AutoDisposeStreamProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
