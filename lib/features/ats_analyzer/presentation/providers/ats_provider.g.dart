// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyzeResumeHash() => r'cd1443bbd83be8dc19a9f8521892780378b80c75';

/// See also [analyzeResume].
@ProviderFor(analyzeResume)
final analyzeResumeProvider = Provider<AnalyzeResume>.internal(
  analyzeResume,
  name: r'analyzeResumeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyzeResumeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyzeResumeRef = ProviderRef<AnalyzeResume>;
String _$atsNotifierHash() => r'57dd8cfd4104aff208cf1d45c875592aac48ad93';

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

abstract class _$AtsNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<AtsResultEntity?>> {
  late final String resumeId;

  AsyncValue<AtsResultEntity?> build(
    String resumeId,
  );
}

/// See also [AtsNotifier].
@ProviderFor(AtsNotifier)
const atsNotifierProvider = AtsNotifierFamily();

/// See also [AtsNotifier].
class AtsNotifierFamily extends Family<AsyncValue<AtsResultEntity?>> {
  /// See also [AtsNotifier].
  const AtsNotifierFamily();

  /// See also [AtsNotifier].
  AtsNotifierProvider call(
    String resumeId,
  ) {
    return AtsNotifierProvider(
      resumeId,
    );
  }

  @override
  AtsNotifierProvider getProviderOverride(
    covariant AtsNotifierProvider provider,
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
  String? get name => r'atsNotifierProvider';
}

/// See also [AtsNotifier].
class AtsNotifierProvider extends AutoDisposeNotifierProviderImpl<AtsNotifier,
    AsyncValue<AtsResultEntity?>> {
  /// See also [AtsNotifier].
  AtsNotifierProvider(
    String resumeId,
  ) : this._internal(
          () => AtsNotifier()..resumeId = resumeId,
          from: atsNotifierProvider,
          name: r'atsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$atsNotifierHash,
          dependencies: AtsNotifierFamily._dependencies,
          allTransitiveDependencies:
              AtsNotifierFamily._allTransitiveDependencies,
          resumeId: resumeId,
        );

  AtsNotifierProvider._internal(
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
  AsyncValue<AtsResultEntity?> runNotifierBuild(
    covariant AtsNotifier notifier,
  ) {
    return notifier.build(
      resumeId,
    );
  }

  @override
  Override overrideWith(AtsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AtsNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<AtsNotifier, AsyncValue<AtsResultEntity?>>
      createElement() {
    return _AtsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AtsNotifierProvider && other.resumeId == resumeId;
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
mixin AtsNotifierRef
    on AutoDisposeNotifierProviderRef<AsyncValue<AtsResultEntity?>> {
  /// The parameter `resumeId` of this provider.
  String get resumeId;
}

class _AtsNotifierProviderElement extends AutoDisposeNotifierProviderElement<
    AtsNotifier, AsyncValue<AtsResultEntity?>> with AtsNotifierRef {
  _AtsNotifierProviderElement(super.provider);

  @override
  String get resumeId => (origin as AtsNotifierProvider).resumeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
