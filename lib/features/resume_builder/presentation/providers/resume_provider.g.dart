// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firestoreHash() => r'864285def6284159b44f9598dcde96347e0c1dce';

/// See also [firestore].
@ProviderFor(firestore)
final firestoreProvider = Provider<FirebaseFirestore>.internal(
  firestore,
  name: r'firestoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirestoreRef = ProviderRef<FirebaseFirestore>;
String _$resumeRemoteDatasourceHash() =>
    r'6d4baf61d949f331b278944102666dc571f8e215';

/// See also [resumeRemoteDatasource].
@ProviderFor(resumeRemoteDatasource)
final resumeRemoteDatasourceProvider =
    Provider<ResumeRemoteDatasource>.internal(
  resumeRemoteDatasource,
  name: r'resumeRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resumeRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResumeRemoteDatasourceRef = ProviderRef<ResumeRemoteDatasource>;
String _$resumeRepositoryHash() => r'cd2a684466cbce88584dad7a99df46a83f5bd738';

/// See also [resumeRepository].
@ProviderFor(resumeRepository)
final resumeRepositoryProvider = Provider<ResumeRepository>.internal(
  resumeRepository,
  name: r'resumeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resumeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResumeRepositoryRef = ProviderRef<ResumeRepository>;
String _$getResumeHash() => r'046f5bcee10a774d47aed210c46077c7d078a527';

/// See also [getResume].
@ProviderFor(getResume)
final getResumeProvider = Provider<GetResume>.internal(
  getResume,
  name: r'getResumeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getResumeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetResumeRef = ProviderRef<GetResume>;
String _$saveResumeHash() => r'8cc36ba57e91e691a26b7be52746eb660ee7d296';

/// See also [saveResume].
@ProviderFor(saveResume)
final saveResumeProvider = Provider<SaveResume>.internal(
  saveResume,
  name: r'saveResumeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$saveResumeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SaveResumeRef = ProviderRef<SaveResume>;
String _$createResumeHash() => r'67c48599d8ffc91c9d3ae47b0dd5055bc420aa24';

/// See also [createResume].
@ProviderFor(createResume)
final createResumeProvider = Provider<CreateResume>.internal(
  createResume,
  name: r'createResumeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$createResumeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateResumeRef = ProviderRef<CreateResume>;
String _$deleteResumeHash() => r'd8ce3a57982e2ec8c82a881826bbe88b3bad3e3c';

/// See also [deleteResume].
@ProviderFor(deleteResume)
final deleteResumeProvider = Provider<DeleteResume>.internal(
  deleteResume,
  name: r'deleteResumeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deleteResumeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteResumeRef = ProviderRef<DeleteResume>;
String _$duplicateResumeHash() => r'e993f6a08db2d4e65f7cd7610d866c24c9d97b09';

/// See also [duplicateResume].
@ProviderFor(duplicateResume)
final duplicateResumeProvider = Provider<DuplicateResume>.internal(
  duplicateResume,
  name: r'duplicateResumeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$duplicateResumeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DuplicateResumeRef = ProviderRef<DuplicateResume>;
String _$resumeListHash() => r'890aafe8ba27dda79dc935f88f69e59c1706cfc5';

/// See also [resumeList].
@ProviderFor(resumeList)
final resumeListProvider =
    AutoDisposeStreamProvider<List<ResumeEntity>>.internal(
  resumeList,
  name: r'resumeListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$resumeListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResumeListRef = AutoDisposeStreamProviderRef<List<ResumeEntity>>;
String _$resumeEditorNotifierHash() =>
    r'cf15b6af69e0c854eb4fad6439eaa36c150ac858';

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

abstract class _$ResumeEditorNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<ResumeEntity>> {
  late final String resumeId;

  AsyncValue<ResumeEntity> build(
    String resumeId,
  );
}

/// See also [ResumeEditorNotifier].
@ProviderFor(ResumeEditorNotifier)
const resumeEditorNotifierProvider = ResumeEditorNotifierFamily();

/// See also [ResumeEditorNotifier].
class ResumeEditorNotifierFamily extends Family<AsyncValue<ResumeEntity>> {
  /// See also [ResumeEditorNotifier].
  const ResumeEditorNotifierFamily();

  /// See also [ResumeEditorNotifier].
  ResumeEditorNotifierProvider call(
    String resumeId,
  ) {
    return ResumeEditorNotifierProvider(
      resumeId,
    );
  }

  @override
  ResumeEditorNotifierProvider getProviderOverride(
    covariant ResumeEditorNotifierProvider provider,
  ) {
    return call(
      provider.resumeId,
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
  String? get name => r'resumeEditorNotifierProvider';
}

/// See also [ResumeEditorNotifier].
class ResumeEditorNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ResumeEditorNotifier, AsyncValue<ResumeEntity>> {
  /// See also [ResumeEditorNotifier].
  ResumeEditorNotifierProvider(
    String resumeId,
  ) : this._internal(
          () => ResumeEditorNotifier()..resumeId = resumeId,
          from: resumeEditorNotifierProvider,
          name: r'resumeEditorNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$resumeEditorNotifierHash,
          dependencies: ResumeEditorNotifierFamily._dependencies,
          allTransitiveDependencies:
              ResumeEditorNotifierFamily._allTransitiveDependencies,
          resumeId: resumeId,
        );

  ResumeEditorNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.resumeId,
  }) : super.internal();

  final String resumeId;

  @override
  AsyncValue<ResumeEntity> runNotifierBuild(
    covariant ResumeEditorNotifier notifier,
  ) {
    return notifier.build(
      resumeId,
    );
  }

  @override
  Override overrideWith(ResumeEditorNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ResumeEditorNotifierProvider._internal(
        () => create()..resumeId = resumeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        resumeId: resumeId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ResumeEditorNotifier,
      AsyncValue<ResumeEntity>> createElement() {
    return _ResumeEditorNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResumeEditorNotifierProvider && other.resumeId == resumeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, resumeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ResumeEditorNotifierRef
    on AutoDisposeNotifierProviderRef<AsyncValue<ResumeEntity>> {
  /// The parameter `resumeId` of this provider.
  String get resumeId;
}

class _ResumeEditorNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ResumeEditorNotifier,
        AsyncValue<ResumeEntity>> with ResumeEditorNotifierRef {
  _ResumeEditorNotifierProviderElement(super.provider);

  @override
  String get resumeId => (origin as ResumeEditorNotifierProvider).resumeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
