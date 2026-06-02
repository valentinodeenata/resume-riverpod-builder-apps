import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:resume_riverpod_builder/features/ats_analyzer/domain/entities/ats_result_entity.dart';
import 'package:resume_riverpod_builder/features/ats_analyzer/domain/usecases/analyze_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/get_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/providers/resume_provider.dart';

part 'ats_provider.g.dart';

@Riverpod(keepAlive: true)
AnalyzeResume analyzeResume(Ref ref) => const AnalyzeResume();

@riverpod
class AtsNotifier extends _$AtsNotifier {
  @override
  AsyncValue<AtsResultEntity?> build(String resumeId) => const AsyncData(null);

  Future<void> analyze(String jobDescription) async {
    state = const AsyncLoading();

    final resumeResult = await ref
        .read(getResumeProvider)
        .call(GetResumeParams(resumeId));

    await resumeResult.fold(
      (f) async => state = AsyncError(f.message, StackTrace.current),
      (resume) async {
        final result = await ref
            .read(analyzeResumeProvider)
            .call(AnalyzeResumeParams(resume: resume, jobDescription: jobDescription));

        state = result.fold(
          (f) => AsyncError(f.message, StackTrace.current),
          AsyncData.new,
        );
      },
    );
  }
}
