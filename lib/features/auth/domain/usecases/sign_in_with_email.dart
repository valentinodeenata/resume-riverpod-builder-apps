import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/auth/domain/entities/user_entity.dart';
import 'package:resume_riverpod_builder/features/auth/domain/repositories/auth_repository.dart';

final class SignInWithEmail implements UseCase<UserEntity, SignInWithEmailParams> {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(SignInWithEmailParams params) =>
      _repository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
}

final class SignInWithEmailParams extends Equatable {
  const SignInWithEmailParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
