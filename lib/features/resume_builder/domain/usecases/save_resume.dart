import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/repositories/resume_repository.dart';

final class SaveResume implements UseCase<ResumeEntity, SaveResumeParams> {
  const SaveResume(this._repository);
  final ResumeRepository _repository;

  @override
  Future<Either<Failure, ResumeEntity>> call(SaveResumeParams params) =>
      _repository.updateResume(params.resume);
}

final class SaveResumeParams extends Equatable {
  const SaveResumeParams(this.resume);
  final ResumeEntity resume;

  @override
  List<Object> get props => [resume];
}
