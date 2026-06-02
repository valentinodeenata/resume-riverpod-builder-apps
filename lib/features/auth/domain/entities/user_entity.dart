import 'package:equatable/equatable.dart';

/// Represents an authenticated user in the domain layer.
///
/// Intentionally decoupled from Firebase's [User] model so the
/// domain layer has zero dependency on the data layer.
final class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  @override
  List<Object?> get props => [id, email, displayName, photoUrl];
}
