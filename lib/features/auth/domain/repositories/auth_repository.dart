import 'package:dartz/dartz.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/features/auth/domain/entities/user_entity.dart';

/// Contract for all authentication operations.
///
/// The data layer implements this; the domain layer depends only on this
/// interface, keeping the dependency direction correct.
abstract interface class AuthRepository {
  /// Emits the current user, or null when signed out.
  Stream<UserEntity?> get authStateChanges;

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<Failure, Unit>> signOut();
}
