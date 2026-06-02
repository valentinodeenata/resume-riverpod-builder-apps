import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/auth/domain/entities/user_entity.dart';
import 'package:resume_riverpod_builder/features/auth/domain/repositories/auth_repository.dart';

final class RegisterWithEmail implements UseCase<UserEntity, RegisterWithEmailParams> {
  const RegisterWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(RegisterWithEmailParams params) =>
      _repository.registerWithEmailAndPassword(
        email: params.email,
        password: params.password,
        displayName: params.displayName,
      );
}

final class RegisterWithEmailParams extends Equatable {
  const RegisterWithEmailParams({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;

  @override
  List<Object> get props => [email, password, displayName];
}
