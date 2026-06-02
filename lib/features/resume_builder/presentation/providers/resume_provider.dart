import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:resume_riverpod_builder/features/auth/presentation/providers/auth_provider.dart';
import 'package:resume_riverpod_builder/features/resume_builder/data/datasources/resume_remote_datasource.dart';
import 'package:resume_riverpod_builder/features/resume_builder/data/repositories/resume_repository_impl.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/repositories/resume_repository.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/create_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/delete_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/get_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/save_resume.dart';

part 'resume_provider.g.dart';

// ─── Infrastructure ───────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
ResumeRemoteDatasource resumeRemoteDatasource(Ref ref) =>
    ResumeRemoteDatasourceImpl(ref.watch(firestoreProvider));

@Riverpod(keepAlive: true)
ResumeRepository resumeRepository(Ref ref) =>
    ResumeRepositoryImpl(ref.watch(resumeRemoteDatasourceProvider));

// ─── Use cases ────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
GetResume getResume(Ref ref) => GetResume(ref.watch(resumeRepositoryProvider));

@Riverpod(keepAlive: true)
SaveResume saveResume(Ref ref) => SaveResume(ref.watch(resumeRepositoryProvider));

@Riverpod(keepAlive: true)
CreateResume createResume(Ref ref) =>
    CreateResume(ref.watch(resumeRepositoryProvider));

@Riverpod(keepAlive: true)
DeleteResume deleteResume(Ref ref) =>
    DeleteResume(ref.watch(resumeRepositoryProvider));

// ─── Resume list stream ───────────────────────────────────────────────────────

@riverpod
Stream<List<ResumeEntity>> resumeList(Ref ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();

  return ref
      .watch(resumeRepositoryProvider)
      .watchResumes(user.id)
      .map((either) => either.fold((_) => [], (list) => list));
}

// ─── Save status ─────────────────────────────────────────────────────────────

enum SaveStatus { idle, saving, saved, error }

/// Simple StateProvider — no code generation needed, no naming conflict risk.
final saveStatusProvider = StateProvider<SaveStatus>((_) => SaveStatus.idle);

// ─── Single resume editor state ───────────────────────────────────────────────

@riverpod
class ResumeEditorNotifier extends _$ResumeEditorNotifier {
  Timer? _debounce;

  @override
  AsyncValue<ResumeEntity> build(String resumeId) {
    ref.onDispose(() => _debounce?.cancel());
    _load(resumeId);
    return const AsyncLoading();
  }

  Future<void> _load(String resumeId) async {
    final result = await ref.read(getResumeProvider).call(GetResumeParams(resumeId));
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      AsyncData.new,
    );
  }

  /// Updates local state immediately (optimistic), then debounces the
  /// Firestore write so rapid changes (e.g. typing) don't flood the network.
  void update(ResumeEntity updated) {
    final draft = updated.copyWith(updatedAt: DateTime.now());
    state = AsyncData(draft);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () => _persist(draft));
  }

  Future<void> _persist(ResumeEntity resume) async {
    ref.read(saveStatusProvider.notifier).state = SaveStatus.saving;
    final result = await ref.read(saveResumeProvider).call(SaveResumeParams(resume));
    ref.read(saveStatusProvider.notifier).state = result.fold(
      (_) => SaveStatus.error,
      (_) => SaveStatus.saved,
    );
    await Future.delayed(const Duration(seconds: 2));
    ref.read(saveStatusProvider.notifier).state = SaveStatus.idle;
  }

  ResumeEntity? get current => state.valueOrNull;
}

// ─── New resume factory ───────────────────────────────────────────────────────

ResumeEntity buildEmptyResume(String userId, String title) => ResumeEntity(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      personalInfo: const PersonalInfoEntity(
        fullName: '',
        email: '',
        phone: '',
        location: '',
      ),
      summary: '',
      experiences: const [],
      educations: const [],
      skillGroups: const [],
      projects: const [],
      certifications: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
