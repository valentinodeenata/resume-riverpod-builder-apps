import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:resume_riverpod_builder/features/auth/presentation/providers/auth_provider.dart';
import 'package:resume_riverpod_builder/features/profile/presentation/providers/profile_provider.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_button.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).valueOrNull;
    _nameController = TextEditingController(text: user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    await ref
        .read(profileNotifierProvider.notifier)
        .updateDisplayName(_nameController.text);
    if (mounted) setState(() => _isEditing = false);
  }

  void _showPhotoOptions(BuildContext context, WidgetRef ref, bool isLoading) {
    if (isLoading) return;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(profileNotifierProvider.notifier)
                      .updatePhoto(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(profileNotifierProvider.notifier)
                      .updatePhoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(profileNotifierProvider.notifier).removePhoto();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final updateState = ref.watch(profileNotifierProvider);
    final theme = Theme.of(context);
    final isLoading = updateState is ProfileUpdateLoading;

    ref.listen(profileNotifierProvider, (_, next) {
      if (next is ProfileUpdateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
        ref.read(profileNotifierProvider.notifier).reset();
      }
      if (next is ProfileUpdateError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        ref.read(profileNotifierProvider.notifier).reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: () => setState(() {
                _isEditing = false;
                _nameController.text = user?.displayName ?? '';
              }),
              child: const Text('Cancel'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Avatar (tappable) ────────────────────────────────────────
          Center(
            child: GestureDetector(
              onTap: () => _showPhotoOptions(context, ref, isLoading),
              child: Stack(
                children: [
                  _Avatar(
                    name: user?.displayName ?? user?.email ?? '?',
                    networkPhotoUrl: user?.photoUrl,
                    radius: 52,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(8),
          Center(
            child: Text(
              'Tap to change photo',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Gap(24),

          // ── Name field ───────────────────────────────────────────────
          Text('Display Name', style: theme.textTheme.labelLarge),
          const Gap(8),
          if (_isEditing)
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your full name',
              ),
              onFieldSubmitted: (_) => _saveName(),
            )
          else
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                (user?.displayName ?? '').isNotEmpty
                    ? user!.displayName
                    : 'Not set',
                style: theme.textTheme.bodyLarge,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit name',
                onPressed: () => setState(() => _isEditing = true),
              ),
            ),

          if (_isEditing) ...[
            const Gap(12),
            AppButton(
              label: 'Save',
              isLoading: isLoading,
              onPressed: isLoading ? null : _saveName,
            ),
          ],

          const Gap(24),
          const Divider(),
          const Gap(24),

          // ── Email (read-only) ─────────────────────────────────────────
          Text('Email', style: theme.textTheme.labelLarge),
          const Gap(8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.email_outlined),
            title: Text(user?.email ?? '-', style: theme.textTheme.bodyLarge),
          ),

          const Gap(24),
          const Divider(),
          const Gap(32),

          // ── Sign out ─────────────────────────────────────────────────
          AppButton.outlined(
            label: 'Sign Out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
    );
  }
}

/// Circular avatar — priority: local file → Google photo → initials.
class _Avatar extends ConsumerWidget {
  const _Avatar({
    required this.name,
    this.networkPhotoUrl,
    this.radius = 40,
  });

  final String name;
  final String? networkPhotoUrl;
  final double radius;

  String get _initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localPath = ref.watch(localPhotoPathProvider);

    // 1️⃣ Local file (user uploaded)
    if (localPath != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(File(localPath)),
      );
    }

    // 2️⃣ Google / network photo
    if (networkPhotoUrl != null && networkPhotoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(networkPhotoUrl!),
      );
    }

    // 3️⃣ Initials fallback
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        _initials,
        style: theme.textTheme.headlineMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
