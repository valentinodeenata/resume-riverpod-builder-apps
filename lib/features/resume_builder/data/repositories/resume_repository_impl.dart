import 'package:dartz/dartz.dart';

import 'package:resume_riverpod_builder/core/error/exceptions.dart';
import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/features/resume_builder/data/datasources/resume_remote_datasource.dart';
import 'package:resume_riverpod_builder/features/resume_builder/data/models/resume_model.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/repositories/resume_repository.dart';

final class ResumeRepositoryImpl implements ResumeRepository {
  const ResumeRepositoryImpl(this._datasource);

  final ResumeRemoteDatasource _datasource;

  @override
  Stream<Either<Failure, List<ResumeEntity>>> watchResumes(String userId) =>
      _datasource.watchResumes(userId).map<Either<Failure, List<ResumeEntity>>>(
            (models) => Right(models.map((m) => m.toEntity()).toList()),
          );

  @override
  Future<Either<Failure, ResumeEntity>> getResume(String resumeId) async {
    try {
      final model = await _datasource.getResume(resumeId);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ResumeEntity>> createResume(ResumeEntity resume) async {
    try {
      final model = await _datasource.createResume(ResumeModel.fromEntity(resume));
      return Right(model.toEntity());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ResumeEntity>> updateResume(ResumeEntity resume) async {
    try {
      final model = await _datasource.updateResume(ResumeModel.fromEntity(resume));
      return Right(model.toEntity());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteResume(String resumeId) async {
    try {
      await _datasource.deleteResume(resumeId);
      return const Right(unit);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ResumeEntity>> duplicateResume(String resumeId) async {
    try {
      final model = await _datasource.duplicateResume(resumeId);
      return Right(model.toEntity());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
