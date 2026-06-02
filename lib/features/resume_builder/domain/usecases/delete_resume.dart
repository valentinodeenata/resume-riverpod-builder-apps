import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/repositories/resume_repository.dart';

final class DeleteResume implements UseCase<Unit, DeleteResumeParams> {
  const DeleteResume(this._repository);
  final ResumeRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteResumeParams params) =>
      _repository.deleteResume(params.resumeId);
}

final class DeleteResumeParams extends Equatable {
  const DeleteResumeParams(this.resumeId);
  final String resumeId;

  @override
  List<Object> get props => [resumeId];
}
