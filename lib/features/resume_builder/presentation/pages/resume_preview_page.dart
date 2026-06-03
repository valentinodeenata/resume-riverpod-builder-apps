import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:resume_riverpod_builder/core/router/route_names.dart';
import 'package:resume_riverpod_builder/features/export/domain/usecases/generate_pdf.dart';
import 'package:resume_riverpod_builder/features/export/presentation/providers/export_provider.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/providers/resume_provider.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_loading.dart';
import 'package:resume_riverpod_builder/shared/widgets/error_view.dart';

/// Shows a live PDF preview using the [PdfPreview] widget from the `printing`
/// package, then lets the user jump straight to the export page.
class ResumePreviewPage extends ConsumerWidget {
  const ResumePreviewPage({super.key, required this.resumeId});

  final String resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(resumeEditorNotifierProvider(resumeId));

    return editorState.when(
      loading: () => const AppLoading(),
      error: (e, _) => Scaffold(body: ErrorView(message: e.toString())),
      data: (resume) => Scaffold(
        appBar: AppBar(
          title: Text(resume.title),
          actions: [
            FilledButton.icon(
              onPressed: () => context.pushNamed(
                RouteNames.export,
                pathParameters: {'resumeId': resumeId},
              ),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Export'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: PdfPreview(
          // Regenerate PDF whenever resume changes
          key: ValueKey(resume.updatedAt),
          build: (format) async {
            final result = await ref
                .read(generatePdfProvider)
                .call(GeneratePdfParams(resume));
            return result.fold(
              (f) => throw Exception(f.message),
              (bytes) => bytes,
            );
          },
          allowPrinting: false,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          pdfFileName: '${resume.title}.pdf',
          loadingWidget: const Center(child: CircularProgressIndicator()),
          initialPageFormat: PdfPageFormat.a4,
        ),
      ),
    );
  }
}
