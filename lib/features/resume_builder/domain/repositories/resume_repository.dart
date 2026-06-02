import 'package:dartz/dartz.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';

abstract interface class ResumeRepository {
  Stream<Either<Failure, List<ResumeEntity>>> watchResumes(String userId);
  Future<Either<Failure, ResumeEntity>> getResume(String resumeId);
  Future<Either<Failure, ResumeEntity>> createResume(ResumeEntity resume);
  Future<Either<Failure, ResumeEntity>> updateResume(ResumeEntity resume);
  Future<Either<Failure, Unit>> deleteResume(String resumeId);
  Future<Either<Failure, ResumeEntity>> duplicateResume(String resumeId);
}
