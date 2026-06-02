import 'package:dartz/dartz.dart';

import 'package:resume_riverpod_builder/core/error/exceptions.dart';
import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:resume_riverpod_builder/features/auth/domain/entities/user_entity.dart';
import 'package:resume_riverpod_builder/features/auth/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Stream<UserEntity?> get authStateChanges =>
      _datasource.authStateChanges.map((model) => model?.toEntity());

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _datasource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _datasource.signInWithGoogle();
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final user = await _datasource.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _datasource.signOut();
      return const Right(unit);
    } on Exception {
      return const Left(ServerFailure());
    }
  }
}
