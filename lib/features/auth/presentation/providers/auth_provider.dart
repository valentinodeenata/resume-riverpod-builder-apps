import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:resume_riverpod_builder/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:resume_riverpod_builder/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:resume_riverpod_builder/features/auth/domain/entities/user_entity.dart';
import 'package:resume_riverpod_builder/features/auth/domain/repositories/auth_repository.dart';
import 'package:resume_riverpod_builder/features/auth/domain/usecases/register_with_email.dart';
import 'package:resume_riverpod_builder/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:resume_riverpod_builder/features/auth/domain/usecases/sign_in_with_google.dart';

part 'auth_provider.g.dart';

// ─── Infrastructure providers ────────────────────────────────────────────────

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn();

@Riverpod(keepAlive: true)
AuthRemoteDatasource authRemoteDatasource(Ref ref) =>
    AuthRemoteDatasourceImpl(
      firebaseAuth: ref.watch(firebaseAuthProvider),
      googleSignIn: ref.watch(googleSignInProvider),
    );

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider));

// ─── Use case providers ───────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
SignInWithEmail signInWithEmail(Ref ref) =>
    SignInWithEmail(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
SignInWithGoogle signInWithGoogle(Ref ref) =>
    SignInWithGoogle(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
RegisterWithEmail registerWithEmail(Ref ref) =>
    RegisterWithEmail(ref.watch(authRepositoryProvider));

// ─── Auth state stream ────────────────────────────────────────────────────────

/// Emits [UserEntity] when signed in, null when signed out.
/// Used by [AppRouter] for redirect guards.
@Riverpod(keepAlive: true)
Stream<UserEntity?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges;
