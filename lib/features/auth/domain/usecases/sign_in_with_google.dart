import 'package:dartz/dartz.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/auth/domain/entities/user_entity.dart';
import 'package:resume_riverpod_builder/features/auth/domain/repositories/auth_repository.dart';

final class SignInWithGoogle implements UseCase<UserEntity, NoParams> {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) =>
      _repository.signInWithGoogle();
}
