import 'package:equatable/equatable.dart';

/// Root aggregate for a complete resume document.
final class ResumeEntity extends Equatable {
  const ResumeEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.personalInfo,
    required this.summary,
    required this.experiences,
    required this.educations,
    required this.skillGroups,
    required this.projects,
    required this.certifications,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final PersonalInfoEntity personalInfo;
  final String summary;
  final List<ExperienceEntity> experiences;
  final List<EducationEntity> educations;
  final List<SkillGroupEntity> skillGroups;
  final List<ProjectEntity> projects;
  final List<CertificationEntity> certifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  ResumeEntity copyWith({
    String? title,
    PersonalInfoEntity? personalInfo,
    String? summary,
    List<ExperienceEntity>? experiences,
    List<EducationEntity>? educations,
    List<SkillGroupEntity>? skillGroups,
    List<ProjectEntity>? projects,
    List<CertificationEntity>? certifications,
    DateTime? updatedAt,
  }) =>
      ResumeEntity(
        id: id,
        userId: userId,
        title: title ?? this.title,
        personalInfo: personalInfo ?? this.personalInfo,
        summary: summary ?? this.summary,
        experiences: experiences ?? this.experiences,
        educations: educations ?? this.educations,
        skillGroups: skillGroups ?? this.skillGroups,
        projects: projects ?? this.projects,
        certifications: certifications ?? this.certifications,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id, userId, title, personalInfo, summary,
        experiences, educations, skillGroups, projects, certifications,
        createdAt, updatedAt,
      ];
}

final class PersonalInfoEntity extends Equatable {
  const PersonalInfoEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    this.linkedIn,
    this.website,
  });

  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String? linkedIn;
  final String? website;

  @override
  List<Object?> get props => [fullName, email, phone, location, linkedIn, website];
}

final class ExperienceEntity extends Equatable {
  const ExperienceEntity({
    required this.id,
    required this.company,
    required this.role,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.bullets,
  });

  final String id;
  final String company;
  final String role;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final List<String> bullets;

  @override
  List<Object?> get props => [id, company, role, startDate, endDate, isCurrent, bullets];
}

final class EducationEntity extends Equatable {
  const EducationEntity({
    required this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    this.endYear,
    this.gpa,
  });

  final String id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startYear;
  final String? endYear;
  final String? gpa;

  @override
  List<Object?> get props => [id, institution, degree, fieldOfStudy, startYear, endYear, gpa];
}

final class SkillGroupEntity extends Equatable {
  const SkillGroupEntity({
    required this.id,
    required this.category,
    required this.skills,
  });

  final String id;
  final String category;
  final List<String> skills;

  @override
  List<Object?> get props => [id, category, skills];
}

final class ProjectEntity extends Equatable {
  const ProjectEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.techStack,
    this.url,
  });

  final String id;
  final String name;
  final String description;
  final List<String> techStack;
  final String? url;

  @override
  List<Object?> get props => [id, name, description, techStack, url];
}

final class CertificationEntity extends Equatable {
  const CertificationEntity({
    required this.id,
    required this.name,
    required this.issuer,
    required this.year,
  });

  final String id;
  final String name;
  final String issuer;
  final String year;

  @override
  List<Object?> get props => [id, name, issuer, year];
}
