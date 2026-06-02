// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResumeModel _$ResumeModelFromJson(Map<String, dynamic> json) => ResumeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      personalInfo: PersonalInfoModel.fromJson(
          json['personalInfo'] as Map<String, dynamic>),
      summary: json['summary'] as String,
      experiences: (json['experiences'] as List<dynamic>)
          .map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      educations: (json['educations'] as List<dynamic>)
          .map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      skillGroups: (json['skillGroups'] as List<dynamic>)
          .map((e) => SkillGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List<dynamic>)
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: ResumeModel._dateTimeFromTimestamp(json['createdAt']),
      updatedAt: ResumeModel._dateTimeFromTimestamp(json['updatedAt']),
    );

Map<String, dynamic> _$ResumeModelToJson(ResumeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'personalInfo': instance.personalInfo.toJson(),
      'summary': instance.summary,
      'experiences': instance.experiences.map((e) => e.toJson()).toList(),
      'educations': instance.educations.map((e) => e.toJson()).toList(),
      'skillGroups': instance.skillGroups.map((e) => e.toJson()).toList(),
      'projects': instance.projects.map((e) => e.toJson()).toList(),
      'certifications': instance.certifications.map((e) => e.toJson()).toList(),
      'createdAt': ResumeModel._dateTimeToTimestamp(instance.createdAt),
      'updatedAt': ResumeModel._dateTimeToTimestamp(instance.updatedAt),
    };

PersonalInfoModel _$PersonalInfoModelFromJson(Map<String, dynamic> json) =>
    PersonalInfoModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      linkedIn: json['linkedIn'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$PersonalInfoModelToJson(PersonalInfoModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'location': instance.location,
      'linkedIn': instance.linkedIn,
      'website': instance.website,
    };

ExperienceModel _$ExperienceModelFromJson(Map<String, dynamic> json) =>
    ExperienceModel(
      id: json['id'] as String,
      company: json['company'] as String,
      role: json['role'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      isCurrent: json['isCurrent'] as bool? ?? false,
      bullets:
          (json['bullets'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ExperienceModelToJson(ExperienceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company': instance.company,
      'role': instance.role,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'isCurrent': instance.isCurrent,
      'bullets': instance.bullets,
    };

EducationModel _$EducationModelFromJson(Map<String, dynamic> json) =>
    EducationModel(
      id: json['id'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      startYear: json['startYear'] as String,
      endYear: json['endYear'] as String?,
      gpa: json['gpa'] as String?,
    );

Map<String, dynamic> _$EducationModelToJson(EducationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institution': instance.institution,
      'degree': instance.degree,
      'fieldOfStudy': instance.fieldOfStudy,
      'startYear': instance.startYear,
      'endYear': instance.endYear,
      'gpa': instance.gpa,
    };

SkillGroupModel _$SkillGroupModelFromJson(Map<String, dynamic> json) =>
    SkillGroupModel(
      id: json['id'] as String,
      category: json['category'] as String,
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SkillGroupModelToJson(SkillGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'skills': instance.skills,
    };

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) => ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      techStack:
          (json['techStack'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'techStack': instance.techStack,
      'url': instance.url,
    };

CertificationModel _$CertificationModelFromJson(Map<String, dynamic> json) =>
    CertificationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      year: json['year'] as String,
    );

Map<String, dynamic> _$CertificationModelToJson(CertificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'issuer': instance.issuer,
      'year': instance.year,
    };
