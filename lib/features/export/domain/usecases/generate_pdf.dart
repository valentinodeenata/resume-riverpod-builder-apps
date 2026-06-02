import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';

/// Generates a single-column ATS-friendly PDF from a [ResumeEntity].
///
/// ATS design rules applied:
/// - Single column layout (no tables or multi-column)
/// - Standard fonts only (Times / Helvetica)
/// - No images, graphics, or headers/footers with decorative elements
/// - Plain text bullets using hyphen (-)
final class GeneratePdf implements UseCase<Uint8List, GeneratePdfParams> {
  const GeneratePdf();

  @override
  Future<Either<Failure, Uint8List>> call(GeneratePdfParams params) async {
    try {
      final bytes = await _buildPdf(params.resume);
      return Right(bytes);
    } catch (e) {
      return Left(ValidationFailure('Failed to generate PDF: $e'));
    }
  }

  Future<Uint8List> _buildPdf(ResumeEntity resume) async {
    final doc = pw.Document();
    final info = resume.personalInfo;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        build: (context) => [
          // ── Header ────────────────────────────────────────────────────────
          pw.Text(
            info.fullName,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            [info.email, info.phone, info.location, if (info.linkedIn != null) info.linkedIn!]
                .join(' | '),
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Divider(height: 12),

          // ── Summary ───────────────────────────────────────────────────────
          if (resume.summary.isNotEmpty) ...[
            _sectionHeader('SUMMARY'),
            pw.Text(resume.summary, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 8),
          ],

          // ── Experience ────────────────────────────────────────────────────
          if (resume.experiences.isNotEmpty) ...[
            _sectionHeader('EXPERIENCE'),
            ...resume.experiences.map(
              (exp) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(exp.role, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        '${exp.startDate} – ${exp.isCurrent ? 'Present' : (exp.endDate ?? '')}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Text(exp.company, style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 2),
                  ...exp.bullets.map(
                    (b) => pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
                      child: pw.Text('- $b', style: const pw.TextStyle(fontSize: 10)),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                ],
              ),
            ),
          ],

          // ── Education ─────────────────────────────────────────────────────
          if (resume.educations.isNotEmpty) ...[
            _sectionHeader('EDUCATION'),
            ...resume.educations.map(
              (edu) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        '${edu.degree} in ${edu.fieldOfStudy}',
                        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        '${edu.startYear}–${edu.endYear ?? 'Present'}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Text(edu.institution, style: const pw.TextStyle(fontSize: 10)),
                  if (edu.gpa != null) pw.Text('GPA: ${edu.gpa}', style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 6),
                ],
              ),
            ),
          ],

          // ── Skills ────────────────────────────────────────────────────────
          if (resume.skillGroups.isNotEmpty) ...[
            _sectionHeader('SKILLS'),
            ...resume.skillGroups.map(
              (g) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 3),
                child: pw.Text(
                  '${g.category}: ${g.skills.join(', ')}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _sectionHeader(String title) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Divider(height: 6, thickness: 0.5),
          pw.SizedBox(height: 4),
        ],
      );
}

final class GeneratePdfParams extends Equatable {
  const GeneratePdfParams(this.resume);
  final ResumeEntity resume;

  @override
  List<Object> get props => [resume];
}
