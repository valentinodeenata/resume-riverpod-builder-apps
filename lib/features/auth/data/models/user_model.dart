import 'package:firebase_auth/firebase_auth.dart';

import 'package:resume_riverpod_builder/features/auth/domain/entities/user_entity.dart';

/// Firebase [User] → domain [UserEntity] adapter.
final class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  factory UserModel.fromFirebase(User user) => UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? user.email?.split('@').first ?? 'User',
        photoUrl: user.photoURL,
      );

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
}
