import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/repositories/resume_repository.dart';

final class CreateResume implements UseCase<ResumeEntity, CreateResumeParams> {
  const CreateResume(this._repository);
  final ResumeRepository _repository;

  @override
  Future<Either<Failure, ResumeEntity>> call(CreateResumeParams params) =>
      _repository.createResume(params.resume);
}

final class CreateResumeParams extends Equatable {
  const CreateResumeParams(this.resume);
  final ResumeEntity resume;

  @override
  List<Object> get props => [resume];
}
