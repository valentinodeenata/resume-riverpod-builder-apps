import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:resume_riverpod_builder/core/error/exceptions.dart';
import 'package:resume_riverpod_builder/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signInWithEmailAndPassword({required String email, required String password});
  Future<UserModel> signInWithGoogle();
  Future<UserModel> registerWithEmailAndPassword({required String email, required String password, required String displayName});
  Future<void> signOut();
}

final class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _auth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<UserModel?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null ? UserModel.fromFirebase(user) : null);

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign in failed.');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const AuthException('Google sign in cancelled.');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return UserModel.fromFirebase(result.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google sign in failed.');
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      await credential.user!.reload();
      return UserModel.fromFirebase(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed.');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
