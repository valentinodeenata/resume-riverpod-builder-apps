import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:resume_riverpod_builder/features/export/presentation/providers/export_provider.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_button.dart';

class ExportPage extends ConsumerWidget {
  const ExportPage({super.key, required this.resumeId});
  final String resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exportNotifierProvider(resumeId));
    final theme = Theme.of(context);
    final isLoading = state is ExportLoading;

    ref.listen(exportNotifierProvider(resumeId), (_, next) {
      if (next is ExportError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: theme.colorScheme.error),
        );
      }
      if (next is ExportSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF exported successfully!')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Export Resume')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.picture_as_pdf, size: 72, color: theme.colorScheme.primary),
            const Gap(16),
            Text(
              'Export as PDF',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              'Your resume will be exported in ATS-friendly single-column PDF format.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const Gap(32),
            const _FormatNote(
              icon: Icons.check_circle_outline,
              text: 'Single-column layout (ATS compatible)',
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
              text: 'No images or graphics',
              color: Colors.green,
            ),
            const Gap(32),
            AppButton(
              label: 'Download PDF',
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () => ref.read(exportNotifierProvider(resumeId).notifier).exportPdf(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormatNote extends StatelessWidget {
  const _FormatNote({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 18),
          const Gap(8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      );
}
