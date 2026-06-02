/// Global application constants.
///
/// Centralizes magic strings and values to prevent typos
/// and make app-wide changes trivial.
library;

class AppConstants {
  AppConstants._();

  static const String appName = 'ATS Resume Builder';
  static const String appVersion = '1.0.0';

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String resumesCollection = 'resumes';

  // Firebase Storage paths
  static const String resumePdfsPath = 'resume_pdfs';
  static const String userAvatarsPath = 'user_avatars';

  // SharedPreferences keys
  static const String themeKey = 'app_theme_mode';

  // ATS scoring weights (must sum to 1.0)
  static const double atsKeywordWeight = 0.50;
  static const double atsFormatWeight = 0.25;
  static const double atsSectionWeight = 0.25;

  // ATS score thresholds
  static const int atsScoreExcellent = 80;
  static const int atsScoreGood = 60;
  static const int atsScoreFair = 40;

  // Resume constraints
  static const int maxResumesPerUser = 10;
  static const int maxBulletsPerExperience = 6;
  static const int maxSkillsPerCategory = 15;
}
