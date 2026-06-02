import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:printing/printing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:resume_riverpod_builder/features/export/domain/usecases/generate_pdf.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/get_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/providers/resume_provider.dart';

part 'export_provider.g.dart';

@Riverpod(keepAlive: true)
GeneratePdf generatePdf(Ref ref) => const GeneratePdf();

sealed class ExportState {
  const ExportState();
}

final class ExportIdle extends ExportState {
  const ExportIdle();
}

final class ExportLoading extends ExportState {
  const ExportLoading();
}

final class ExportSuccess extends ExportState {
  const ExportSuccess();
}

final class ExportError extends ExportState {
  const ExportError(this.message);
  final String message;
}

@riverpod
class ExportNotifier extends _$ExportNotifier {
  @override
  ExportState build(String resumeId) => const ExportIdle();

  Future<void> exportPdf() async {
    state = const ExportLoading();

    final resumeResult = await ref
        .read(getResumeProvider)
        .call(GetResumeParams(resumeId));

    await resumeResult.fold(
      (f) async => state = ExportError(f.message),
      (resume) async {
        final pdfResult = await ref.read(generatePdfProvider).call(GeneratePdfParams(resume));

        await pdfResult.fold(
          (f) async => state = ExportError(f.message),
          (bytes) async {
            await Printing.layoutPdf(onLayout: (_) => bytes, name: '${resume.title}.pdf');
            state = const ExportSuccess();
          },
        );
      },
    );
  }
}
