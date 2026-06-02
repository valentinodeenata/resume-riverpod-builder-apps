import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:resume_riverpod_builder/core/router/route_names.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/providers/resume_provider.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_certifications.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_education.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_experience.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_personal_info.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_projects.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_skills.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_summary.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_loading.dart';
import 'package:resume_riverpod_builder/shared/widgets/error_view.dart';

class ResumeEditorPage extends ConsumerWidget {
  const ResumeEditorPage({super.key, required this.resumeId});

  final String resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(resumeEditorNotifierProvider(resumeId));

    return editorState.when(
      loading: () => const AppLoading(),
      error: (e, _) => Scaffold(body: ErrorView(message: e.toString())),
      data: (resume) => _EditorScaffold(resume: resume, resumeId: resumeId),
    );
  }
}

class _EditorScaffold extends ConsumerWidget {
  const _EditorScaffold({required this.resume, required this.resumeId});

  final ResumeEntity resume;
  final String resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(resumeEditorNotifierProvider(resumeId).notifier);
    final saveStatus = ref.watch(saveStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(resume.title),
        actions: [
          // ── Save status indicator ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _SaveStatusChip(status: saveStatus),
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'ATS Analysis',
            onPressed: () => context.pushNamed(
              RouteNames.atsAnalyzer,
              pathParameters: {'resumeId': resumeId},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Export PDF',
            onPressed: () => context.pushNamed(
              RouteNames.export,
              pathParameters: {'resumeId': resumeId},
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionPersonalInfo(
            info: resume.personalInfo,
            onChanged: (info) => notifier.update(resume.copyWith(personalInfo: info)),
          ),
          const Gap(12),
          SectionSummary(
            summary: resume.summary,
            onChanged: (s) => notifier.update(resume.copyWith(summary: s)),
          ),
          const Gap(12),
          SectionExperience(
            experiences: resume.experiences,
            onChanged: (list) => notifier.update(resume.copyWith(experiences: list)),
          ),
          const Gap(12),
          SectionEducation(
            educations: resume.educations,
            onChanged: (list) => notifier.update(resume.copyWith(educations: list)),
          ),
          const Gap(12),
          SectionSkills(
            skillGroups: resume.skillGroups,
            onChanged: (list) => notifier.update(resume.copyWith(skillGroups: list)),
          ),
          const Gap(12),
          SectionProjects(
            projects: resume.projects,
            onChanged: (list) => notifier.update(resume.copyWith(projects: list)),
          ),
          const Gap(12),
          SectionCertifications(
            certifications: resume.certifications,
            onChanged: (list) => notifier.update(resume.copyWith(certifications: list)),
          ),
          const Gap(80),
        ],
      ),
    );
  }
}

class _SaveStatusChip extends StatelessWidget {
  const _SaveStatusChip({required this.status});

  final SaveStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return switch (status) {
      SaveStatus.idle => const SizedBox.shrink(),
      SaveStatus.saving => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(6),
            Text(
              'Saving...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      SaveStatus.saved => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 14, color: Colors.green.shade600),
            const Gap(4),
            Text(
              'Saved',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.green.shade600),
            ),
          ],
        ),
      SaveStatus.error => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 14, color: theme.colorScheme.error),
            const Gap(4),
            Text(
              'Save failed',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
            ),
          ],
        ),
    };
  }
}
