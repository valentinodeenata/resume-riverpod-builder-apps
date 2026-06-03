// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generatePdfHash() => r'fc33b6ac06086fe7a44ce91b5763a2b7aa119290';

/// See also [generatePdf].
@ProviderFor(generatePdf)
final generatePdfProvider = Provider<GeneratePdf>.internal(
  generatePdf,
  name: r'generatePdfProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$generatePdfHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GeneratePdfRef = ProviderRef<GeneratePdf>;
String _$exportNotifierHash() => r'1740f5457dfae28d4266f16c85d4980325575014';

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

abstract class _$ExportNotifier
    extends BuildlessAutoDisposeNotifier<ExportState> {
  late final String resumeId;

  ExportState build(
    String resumeId,
  );
}

/// See also [ExportNotifier].
@ProviderFor(ExportNotifier)
const exportNotifierProvider = ExportNotifierFamily();

/// See also [ExportNotifier].
class ExportNotifierFamily extends Family<ExportState> {
  /// See also [ExportNotifier].
  const ExportNotifierFamily();

  /// See also [ExportNotifier].
  ExportNotifierProvider call(
    String resumeId,
  ) {
    return ExportNotifierProvider(
      resumeId,
    );
  }

  @override
  ExportNotifierProvider getProviderOverride(
    covariant ExportNotifierProvider provider,
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
  String? get name => r'exportNotifierProvider';
}

/// See also [ExportNotifier].
class ExportNotifierProvider
    extends AutoDisposeNotifierProviderImpl<ExportNotifier, ExportState> {
  /// See also [ExportNotifier].
  ExportNotifierProvider(
    String resumeId,
  ) : this._internal(
          () => ExportNotifier()..resumeId = resumeId,
          from: exportNotifierProvider,
          name: r'exportNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exportNotifierHash,
          dependencies: ExportNotifierFamily._dependencies,
          allTransitiveDependencies:
              ExportNotifierFamily._allTransitiveDependencies,
          resumeId: resumeId,
        );

  ExportNotifierProvider._internal(
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
  ExportState runNotifierBuild(
    covariant ExportNotifier notifier,
  ) {
    return notifier.build(
      resumeId,
    );
  }

  @override
  Override overrideWith(ExportNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExportNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ExportNotifier, ExportState>
      createElement() {
    return _ExportNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExportNotifierProvider && other.resumeId == resumeId;
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
mixin ExportNotifierRef on AutoDisposeNotifierProviderRef<ExportState> {
  /// The parameter `resumeId` of this provider.
  String get resumeId;
}

class _ExportNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ExportNotifier, ExportState>
    with ExportNotifierRef {
  _ExportNotifierProviderElement(super.provider);

  @override
  String get resumeId => (origin as ExportNotifierProvider).resumeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
