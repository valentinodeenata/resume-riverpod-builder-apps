import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:resume_riverpod_builder/features/auth/presentation/providers/auth_provider.dart';

part 'profile_provider.g.dart';

// ─── Local photo path provider ────────────────────────────────────────────────

/// Key prefix stored in SharedPreferences.
String _photoKey(String userId) => 'profile_photo_$userId';

/// Exposes the current local photo file path (null = use initials/Google photo).
final localPhotoPathProvider = StateProvider<String?>((ref) {
  // Loaded asynchronously in ProfileNotifier.build()
  return null;
});

// ─── State ───────────────────────────────────────────────────────────────────

sealed class ProfileUpdateState {
  const ProfileUpdateState();
}

final class ProfileUpdateIdle extends ProfileUpdateState {
  const ProfileUpdateIdle();
}

final class ProfileUpdateLoading extends ProfileUpdateState {
  const ProfileUpdateLoading();
}

final class ProfileUpdateSuccess extends ProfileUpdateState {
  const ProfileUpdateSuccess(this.message);
  final String message;
}

final class ProfileUpdateError extends ProfileUpdateState {
  const ProfileUpdateError(this.message);
  final String message;
}

// ─── Notifier ────────────────────────────────────────────────────────────────

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileUpdateState build() {
    // Load saved photo path on startup
    _loadSavedPhoto();
    return const ProfileUpdateIdle();
  }

  Future<void> _loadSavedPhoto() async {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_photoKey(userId));
    if (path != null && File(path).existsSync()) {
      ref.read(localPhotoPathProvider.notifier).state = path;
    }
  }

  /// Updates the user's display name in Firebase Auth.
  Future<void> updateDisplayName(String newName) async {
    if (newName.trim().isEmpty) return;
    state = const ProfileUpdateLoading();
    try {
      final user = ref.read(firebaseAuthProvider).currentUser;
      await user?.updateDisplayName(newName.trim());
      await user?.reload();
      ref.invalidate(authStateProvider);
      state = const ProfileUpdateSuccess('Name updated successfully!');
    } on FirebaseAuthException catch (e) {
      state = ProfileUpdateError(e.message ?? 'Failed to update name.');
    } catch (_) {
      state = const ProfileUpdateError('An unexpected error occurred.');
    }
  }

  /// Picks an image from [source] and saves it to local app storage.
  Future<void> updatePhoto(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    state = const ProfileUpdateLoading();
    try {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (userId == null) {
        state = const ProfileUpdateError('Not signed in.');
        return;
      }

      // Save to app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory('${appDir.path}/avatars');
      if (!avatarDir.existsSync()) avatarDir.createSync(recursive: true);

      final bytes = await picked.readAsBytes();
      final file = File('${avatarDir.path}/$userId.jpg');
      await file.writeAsBytes(bytes);

      // Persist path in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_photoKey(userId), file.path);

      // Update live provider so avatar refreshes instantly
      ref.read(localPhotoPathProvider.notifier).state = file.path;

      state = const ProfileUpdateSuccess('Photo updated!');
    } catch (e) {
      state = ProfileUpdateError('Failed to save photo: $e');
    }
  }

  /// Removes the locally stored photo.
  Future<void> removePhoto() async {
    state = const ProfileUpdateLoading();
    try {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (userId == null) return;

      // Delete file if exists
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString(_photoKey(userId));
      if (path != null) {
        final file = File(path);
        if (file.existsSync()) file.deleteSync();
        await prefs.remove(_photoKey(userId));
      }

      ref.read(localPhotoPathProvider.notifier).state = null;
      state = const ProfileUpdateSuccess('Photo removed.');
    } catch (_) {
      state = const ProfileUpdateError('Failed to remove photo.');
    }
  }

  void reset() => state = const ProfileUpdateIdle();
}
