import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:resume_riverpod_builder/core/constants/app_constants.dart';
import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/ats_analyzer/domain/entities/ats_result_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';

/// Runs the full ATS analysis pipeline against a resume and job description.
///
/// This is a pure domain use case with zero Firebase dependencies — all
/// scoring is computed locally from rule-based logic so it works offline.
final class AnalyzeResume implements UseCase<AtsResultEntity, AnalyzeResumeParams> {
  const AnalyzeResume();

  @override
  Future<Either<Failure, AtsResultEntity>> call(AnalyzeResumeParams params) async {
    if (params.jobDescription.trim().isEmpty) {
      return const Left(ValidationFailure('Please paste a job description to analyze.'));
    }
    try {
      final result = _analyze(params.resume, params.jobDescription);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  AtsResultEntity _analyze(ResumeEntity resume, String jobDescription) {
    final jdKeywords = _extractKeywords(jobDescription);
    final resumeText = _flattenResumeText(resume).toLowerCase();

    final matched = jdKeywords.where((k) => resumeText.contains(k)).toList();
    final missing = jdKeywords.where((k) => !resumeText.contains(k)).toList();

    final keywordScore = jdKeywords.isEmpty
        ? 100
        : ((matched.length / jdKeywords.length) * 100).round().clamp(0, 100);

    final formatIssues = _checkFormat(resume);
    final formatScore = (100 - (formatIssues.length * 20)).clamp(0, 100);

    final missingSections = _checkSections(resume);
    final sectionScore = (100 - (missingSections.length * 25)).clamp(0, 100);

    final overall = (keywordScore * AppConstants.atsKeywordWeight +
            formatScore * AppConstants.atsFormatWeight +
            sectionScore * AppConstants.atsSectionWeight)
        .round();

    return AtsResultEntity(
      score: overall,
      keywordScore: keywordScore,
      formatScore: formatScore,
      sectionScore: sectionScore,
      matchedKeywords: matched,
      missingKeywords: missing,
      formatIssues: formatIssues,
      missingSections: missingSections,
    );
  }

  /// Extracts meaningful keywords from a job description (2+ char, non-stopwords).
  List<String> _extractKeywords(String text) {
    const stopWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'is', 'are', 'was', 'were', 'be', 'been',
      'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
      'should', 'may', 'might', 'shall', 'can', 'this', 'that', 'these',
      'those', 'we', 'you', 'they', 'it', 'he', 'she', 'as', 'if', 'not',
    };

    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2 && !stopWords.contains(w))
        .toSet()
        .toList();
  }

  String _flattenResumeText(ResumeEntity r) => [
        r.personalInfo.fullName,
        r.summary,
        ...r.experiences.expand((e) => [e.company, e.role, ...e.bullets]),
        ...r.educations.expand((e) => [e.institution, e.degree, e.fieldOfStudy]),
        ...r.skillGroups.expand((g) => [g.category, ...g.skills]),
        ...r.projects.expand((p) => [p.name, p.description, ...p.techStack]),
        ...r.certifications.map((c) => c.name),
      ].join(' ');

  List<String> _checkFormat(ResumeEntity resume) {
    final issues = <String>[];
    if (resume.personalInfo.email.isEmpty) issues.add('Missing email address');
    if (resume.personalInfo.phone.isEmpty) issues.add('Missing phone number');
    if (resume.summary.length < 50) issues.add('Summary is too short (min 50 characters)');
    if (resume.experiences.any((e) => e.bullets.isEmpty)) {
      issues.add('Some experience entries have no bullet points');
    }
    return issues;
  }

  List<String> _checkSections(ResumeEntity resume) {
    final missing = <String>[];
    if (resume.summary.isEmpty) missing.add('Summary');
    if (resume.experiences.isEmpty) missing.add('Work Experience');
    if (resume.educations.isEmpty) missing.add('Education');
    if (resume.skillGroups.isEmpty) missing.add('Skills');
    return missing;
  }
}

final class AnalyzeResumeParams extends Equatable {
  const AnalyzeResumeParams({
    required this.resume,
    required this.jobDescription,
  });

  final ResumeEntity resume;
  final String jobDescription;

  @override
  List<Object> get props => [resume, jobDescription];
}
