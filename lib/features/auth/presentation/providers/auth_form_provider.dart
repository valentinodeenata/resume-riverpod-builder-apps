import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:resume_riverpod_builder/core/error/failures.dart';
import 'package:resume_riverpod_builder/core/usecase/usecase.dart';
import 'package:resume_riverpod_builder/features/auth/domain/usecases/register_with_email.dart';
import 'package:resume_riverpod_builder/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:resume_riverpod_builder/features/auth/presentation/providers/auth_provider.dart';

part 'auth_form_provider.g.dart';

sealed class AuthFormState {
  const AuthFormState();
}

final class AuthFormInitial extends AuthFormState {
  const AuthFormInitial();
}

final class AuthFormLoading extends AuthFormState {
  const AuthFormLoading();
}

final class AuthFormSuccess extends AuthFormState {
  const AuthFormSuccess();
}

final class AuthFormError extends AuthFormState {
  const AuthFormError(this.message);
  final String message;
}

@riverpod
class AuthFormNotifier extends _$AuthFormNotifier {
  @override
  AuthFormState build() => const AuthFormInitial();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthFormLoading();
    final useCase = ref.read(signInWithEmailProvider);
    final result = await useCase(
      SignInWithEmailParams(email: email, password: password),
    );
    result.fold(
      (failure) => state = AuthFormError(_mapFailureToMessage(failure)),
      (_) => state = const AuthFormSuccess(),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AuthFormLoading();
    final useCase = ref.read(signInWithGoogleProvider);
    final result = await useCase(const NoParams());
    result.fold(
      (failure) => state = AuthFormError(_mapFailureToMessage(failure)),
      (_) => state = const AuthFormSuccess(),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthFormLoading();
    final useCase = ref.read(registerWithEmailProvider);
    final result = await useCase(
      RegisterWithEmailParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
    result.fold(
      (failure) => state = AuthFormError(_mapFailureToMessage(failure)),
      (_) => state = const AuthFormSuccess(),
    );
  }

  void reset() => state = const AuthFormInitial();

  String _mapFailureToMessage(Failure failure) => switch (failure) {
        AuthFailure() => failure.message,
        NetworkFailure() => 'No internet connection. Please try again.',
        ServerFailure() => 'Something went wrong. Please try again.',
        _ => 'An unexpected error occurred.',
      };
}
