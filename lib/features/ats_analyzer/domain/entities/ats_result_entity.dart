import 'package:equatable/equatable.dart';

/// The result of running an ATS analysis on a resume.
final class AtsResultEntity extends Equatable {
  const AtsResultEntity({
    required this.score,
    required this.keywordScore,
    required this.formatScore,
    required this.sectionScore,
    required this.matchedKeywords,
    required this.missingKeywords,
    required this.formatIssues,
    required this.missingSections,
  });

  /// Overall ATS score 0–100.
  final int score;

  /// Sub-scores each 0–100.
  final int keywordScore;
  final int formatScore;
  final int sectionScore;

  final List<String> matchedKeywords;
  final List<String> missingKeywords;
  final List<String> formatIssues;
  final List<String> missingSections;

  String get scoreLabel => switch (score) {
        >= 80 => 'Excellent',
        >= 60 => 'Good',
        >= 40 => 'Fair',
        _ => 'Needs Work',
      };

  @override
  List<Object?> get props => [
        score, keywordScore, formatScore, sectionScore,
        matchedKeywords, missingKeywords, formatIssues, missingSections,
      ];
}
