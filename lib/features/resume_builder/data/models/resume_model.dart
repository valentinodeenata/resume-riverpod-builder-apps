import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';

part 'resume_model.g.dart';

/// Firestore-serializable representation of a [ResumeEntity].
@JsonSerializable(explicitToJson: true)
class ResumeModel {
  const ResumeModel({
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

  factory ResumeModel.fromJson(Map<String, dynamic> json) => _$ResumeModelFromJson(json);

  factory ResumeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ResumeModel.fromJson({...data, 'id': doc.id});
  }

  factory ResumeModel.fromEntity(ResumeEntity entity) => ResumeModel(
        id: entity.id,
        userId: entity.userId,
        title: entity.title,
        personalInfo: PersonalInfoModel.fromEntity(entity.personalInfo),
        summary: entity.summary,
        experiences: entity.experiences.map(ExperienceModel.fromEntity).toList(),
        educations: entity.educations.map(EducationModel.fromEntity).toList(),
        skillGroups: entity.skillGroups.map(SkillGroupModel.fromEntity).toList(),
        projects: entity.projects.map(ProjectModel.fromEntity).toList(),
        certifications: entity.certifications.map(CertificationModel.fromEntity).toList(),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  final String id;
  final String userId;
  final String title;
  final PersonalInfoModel personalInfo;
  final String summary;
  final List<ExperienceModel> experiences;
  final List<EducationModel> educations;
  final List<SkillGroupModel> skillGroups;
  final List<ProjectModel> projects;
  final List<CertificationModel> certifications;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ResumeModelToJson(this);

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  ResumeEntity toEntity() => ResumeEntity(
        id: id,
        userId: userId,
        title: title,
        personalInfo: personalInfo.toEntity(),
        summary: summary,
        experiences: experiences.map((e) => e.toEntity()).toList(),
        educations: educations.map((e) => e.toEntity()).toList(),
        skillGroups: skillGroups.map((e) => e.toEntity()).toList(),
        projects: projects.map((e) => e.toEntity()).toList(),
        certifications: certifications.map((e) => e.toEntity()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static DateTime _dateTimeFromTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  static dynamic _dateTimeToTimestamp(DateTime dt) => dt.toIso8601String();
}

@JsonSerializable()
class PersonalInfoModel {
  const PersonalInfoModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    this.linkedIn,
    this.website,
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoModelFromJson(json);

  factory PersonalInfoModel.fromEntity(PersonalInfoEntity e) => PersonalInfoModel(
        fullName: e.fullName,
        email: e.email,
        phone: e.phone,
        location: e.location,
        linkedIn: e.linkedIn,
        website: e.website,
      );

  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String? linkedIn;
  final String? website;

  Map<String, dynamic> toJson() => _$PersonalInfoModelToJson(this);

  PersonalInfoEntity toEntity() => PersonalInfoEntity(
        fullName: fullName,
        email: email,
        phone: phone,
        location: location,
        linkedIn: linkedIn,
        website: website,
      );
}

@JsonSerializable()
class ExperienceModel {
  const ExperienceModel({
    required this.id,
    required this.company,
    required this.role,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.bullets,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceModelFromJson(json);

  factory ExperienceModel.fromEntity(ExperienceEntity e) => ExperienceModel(
        id: e.id,
        company: e.company,
        role: e.role,
        startDate: e.startDate,
        endDate: e.endDate,
        isCurrent: e.isCurrent,
        bullets: e.bullets,
      );

  final String id;
  final String company;
  final String role;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final List<String> bullets;

  Map<String, dynamic> toJson() => _$ExperienceModelToJson(this);

  ExperienceEntity toEntity() => ExperienceEntity(
        id: id,
        company: company,
        role: role,
        startDate: startDate,
        endDate: endDate,
        isCurrent: isCurrent,
        bullets: bullets,
      );
}

@JsonSerializable()
class EducationModel {
  const EducationModel({
    required this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    this.endYear,
    this.gpa,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) =>
      _$EducationModelFromJson(json);

  factory EducationModel.fromEntity(EducationEntity e) => EducationModel(
        id: e.id,
        institution: e.institution,
        degree: e.degree,
        fieldOfStudy: e.fieldOfStudy,
        startYear: e.startYear,
        endYear: e.endYear,
        gpa: e.gpa,
      );

  final String id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startYear;
  final String? endYear;
  final String? gpa;

  Map<String, dynamic> toJson() => _$EducationModelToJson(this);

  EducationEntity toEntity() => EducationEntity(
        id: id,
        institution: institution,
        degree: degree,
        fieldOfStudy: fieldOfStudy,
        startYear: startYear,
        endYear: endYear,
        gpa: gpa,
      );
}

@JsonSerializable()
class SkillGroupModel {
  const SkillGroupModel({
    required this.id,
    required this.category,
    required this.skills,
  });

  factory SkillGroupModel.fromJson(Map<String, dynamic> json) =>
      _$SkillGroupModelFromJson(json);

  factory SkillGroupModel.fromEntity(SkillGroupEntity e) =>
      SkillGroupModel(id: e.id, category: e.category, skills: e.skills);

  final String id;
  final String category;
  final List<String> skills;

  Map<String, dynamic> toJson() => _$SkillGroupModelToJson(this);

  SkillGroupEntity toEntity() =>
      SkillGroupEntity(id: id, category: category, skills: skills);
}

@JsonSerializable()
class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.techStack,
    this.url,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  factory ProjectModel.fromEntity(ProjectEntity e) => ProjectModel(
        id: e.id,
        name: e.name,
        description: e.description,
        techStack: e.techStack,
        url: e.url,
      );

  final String id;
  final String name;
  final String description;
  final List<String> techStack;
  final String? url;

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  ProjectEntity toEntity() => ProjectEntity(
        id: id,
        name: name,
        description: description,
        techStack: techStack,
        url: url,
      );
}

@JsonSerializable()
class CertificationModel {
  const CertificationModel({
    required this.id,
    required this.name,
    required this.issuer,
    required this.year,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) =>
      _$CertificationModelFromJson(json);

  factory CertificationModel.fromEntity(CertificationEntity e) =>
      CertificationModel(id: e.id, name: e.name, issuer: e.issuer, year: e.year);

  final String id;
  final String name;
  final String issuer;
  final String year;

  Map<String, dynamic> toJson() => _$CertificationModelToJson(this);

  CertificationEntity toEntity() =>
      CertificationEntity(id: id, name: name, issuer: issuer, year: year);
}
