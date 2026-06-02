import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/repositories/resume_repository.dart';

final class GetResume implements UseCase<ResumeEntity, GetResumeParams> {
  const GetResume(this._repository);
  final ResumeRepository _repository;

  @override
  Future<Either<Failure, ResumeEntity>> call(GetResumeParams params) =>
      _repository.getResume(params.resumeId);
}

final class GetResumeParams extends Equatable {
  const GetResumeParams(this.resumeId);
  final String resumeId;

  @override
  List<Object> get props => [resumeId];
}
