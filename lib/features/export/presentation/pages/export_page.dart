import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:resume_riverpod_builder/features/export/presentation/providers/export_provider.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/providers/resume_provider.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_button.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_loading.dart';
import 'package:resume_riverpod_builder/shared/widgets/error_view.dart';

class ExportPage extends ConsumerWidget {
  const ExportPage({super.key, required this.resumeId});
  final String resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(resumeEditorNotifierProvider(resumeId));

    return editorState.when(
      loading: () => const AppLoading(),
      error: (e, _) => Scaffold(body: ErrorView(message: e.toString())),
      data: (resume) => _ExportScaffold(resume: resume, resumeId: resumeId),
    );
  }
}

class _ExportScaffold extends ConsumerWidget {
  const _ExportScaffold({required this.resume, required this.resumeId});

  final ResumeEntity resume;
  final String resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportNotifierProvider(resumeId));
    final theme = Theme.of(context);
    final isLoading = exportState is ExportLoading;

    // Build validation checklist
    final checks = _buildChecks(resume);
    final allPassed = checks.every((c) => c.passed);

    ref.listen(exportNotifierProvider(resumeId), (_, next) {
      if (next is ExportError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
      if (next is ExportSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF downloaded successfully!')),
        );
      }
      if (next is ExportShared) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF shared!')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Export Resume')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const Gap(16),
            Text(
              'Export as PDF',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              'ATS-friendly single-column PDF format.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(32),

            // ── Readiness checklist ───────────────────────────────────
            Text(
              'Resume Readiness',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            ...checks.map((c) => _CheckRow(check: c)),
            const Gap(24),

            // ── Warning banner if not all passed ─────────────────────
            if (!allPassed) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: theme.colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'Complete the missing fields for a stronger resume.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
            ],

            AppButton(
              label: allPassed ? 'Download PDF' : 'Download Anyway',
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () => ref
                      .read(exportNotifierProvider(resumeId).notifier)
                      .exportPdf(),
            ),
            const Gap(12),
            AppButton.outlined(
              label: 'Share PDF',
              icon: const Icon(Icons.share_outlined),
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () => ref
                      .read(exportNotifierProvider(resumeId).notifier)
                      .sharePdf(),
            ),

            // ── ATS format notes ─────────────────────────────────────
            const Gap(32),
            Text(
              'ATS Format',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            const _FormatNote(
              icon: Icons.check_circle_outline,
              text: 'Single-column layout',
              color: Colors.green,
            ),
            const Gap(8),
            const _FormatNote(
              icon: Icons.check_circle_outline,
              text: 'Standard fonts (no custom typefaces)',
              color: Colors.green,
            ),
            const Gap(8),
            const _FormatNote(
              icon: Icons.check_circle_outline,
              text: 'No images or decorative graphics',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  List<_ResumeCheck> _buildChecks(ResumeEntity r) => [
        _ResumeCheck(
          label: 'Full name',
          passed: r.personalInfo.fullName.trim().isNotEmpty,
        ),
        _ResumeCheck(
          label: 'Email address',
          passed: r.personalInfo.email.trim().isNotEmpty,
        ),
        _ResumeCheck(
          label: 'Phone number',
          passed: r.personalInfo.phone.trim().isNotEmpty,
        ),
        _ResumeCheck(
          label: 'Professional summary',
          passed: r.summary.trim().length >= 50,
          hint: 'Min 50 characters',
        ),
        _ResumeCheck(
          label: 'At least one work experience',
          passed: r.experiences.isNotEmpty,
        ),
        _ResumeCheck(
          label: 'Experience entries have bullet points',
          passed: r.experiences.isEmpty ||
              r.experiences.every((e) => e.bullets.isNotEmpty),
          hint: 'Add achievements to each role',
        ),
        _ResumeCheck(
          label: 'At least one education entry',
          passed: r.educations.isNotEmpty,
        ),
        _ResumeCheck(
          label: 'Skills section filled',
          passed: r.skillGroups.isNotEmpty,
        ),
      ];
}

class _ResumeCheck {
  const _ResumeCheck({
    required this.label,
    required this.passed,
    this.hint,
  });

  final String label;
  final bool passed;
  final String? hint;
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.check});
  final _ResumeCheck check;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = check.passed ? Colors.green.shade600 : theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check.passed ? Icons.check_circle : Icons.cancel_outlined,
            color: color,
            size: 20,
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  check.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: check.passed
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.error,
                  ),
                ),
                if (!check.passed && check.hint != null)
                  Text(
                    check.hint!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatNote extends StatelessWidget {
  const _FormatNote({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 18),
          const Gap(8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      );
}
