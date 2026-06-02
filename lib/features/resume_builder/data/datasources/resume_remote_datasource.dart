import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:resume_riverpod_builder/core/constants/app_constants.dart';
import 'package:resume_riverpod_builder/core/error/exceptions.dart';
import 'package:resume_riverpod_builder/features/resume_builder/data/models/resume_model.dart';

abstract interface class ResumeRemoteDatasource {
  Stream<List<ResumeModel>> watchResumes(String userId);
  Future<ResumeModel> getResume(String resumeId);
  Future<ResumeModel> createResume(ResumeModel resume);
  Future<ResumeModel> updateResume(ResumeModel resume);
  Future<void> deleteResume(String resumeId);
  Future<ResumeModel> duplicateResume(String resumeId);
}

final class ResumeRemoteDatasourceImpl implements ResumeRemoteDatasource {
  const ResumeRemoteDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(AppConstants.resumesCollection);

  @override
  Stream<List<ResumeModel>> watchResumes(String userId) => _col
      .where('userId', isEqualTo: userId)
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map(ResumeModel.fromFirestore).toList());

  @override
  Future<ResumeModel> getResume(String resumeId) async {
    try {
      final doc = await _col.doc(resumeId).get();
      if (!doc.exists) throw const NotFoundException();
      return ResumeModel.fromFirestore(doc);
    } on NotFoundException {
      rethrow;
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<ResumeModel> createResume(ResumeModel resume) async {
    try {
      final docRef = _col.doc(resume.id);
      await docRef.set(resume.toFirestore());
      return resume;
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<ResumeModel> updateResume(ResumeModel resume) async {
    try {
      await _col.doc(resume.id).update(resume.toFirestore());
      return resume;
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<void> deleteResume(String resumeId) async {
    try {
      await _col.doc(resumeId).delete();
    } catch (_) {
      throw const ServerException();
    }
  }

  @override
  Future<ResumeModel> duplicateResume(String resumeId) async {
    final original = await getResume(resumeId);
    final copy = ResumeModel(
      id: const Uuid().v4(),
      userId: original.userId,
      title: '${original.title} (Copy)',
      personalInfo: original.personalInfo,
      summary: original.summary,
      experiences: original.experiences,
      educations: original.educations,
      skillGroups: original.skillGroups,
      projects: original.projects,
      certifications: original.certifications,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return createResume(copy);
  }
}
