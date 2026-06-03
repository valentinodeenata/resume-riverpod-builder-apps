import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:resume_riverpod_builder/core/constants/app_constants.dart';
import 'package:resume_riverpod_builder/core/router/route_names.dart';
import 'package:resume_riverpod_builder/core/theme/theme_provider.dart';
import 'package:resume_riverpod_builder/features/auth/presentation/providers/auth_provider.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/create_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/delete_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/domain/usecases/duplicate_resume.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/providers/resume_provider.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_loading.dart';
import 'package:resume_riverpod_builder/shared/widgets/error_view.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeList = ref.watch(resumeListProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle theme',
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile',
            onPressed: () => context.pushNamed(RouteNames.profile),
          ),
        ],
      ),
      body: resumeList.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (_, __) => const AppLoadingCard(height: 88),
        ),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(resumeListProvider),
        ),
        data: (resumes) => resumes.isEmpty
            ? _EmptyState(
                onCreateTap: () => _createResume(context, ref, user?.id ?? ''),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: resumes.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (_, i) => _ResumeCard(
                  resume: resumes[i],
                  onTap: () => context.pushNamed(
                    RouteNames.resumeEditor,
                    pathParameters: {'resumeId': resumes[i].id},
                  ),
                  onAnalyze: () => context.pushNamed(
                    RouteNames.atsAnalyzer,
                    pathParameters: {'resumeId': resumes[i].id},
                  ),
                  onDuplicate: () => _duplicateResume(context, ref, resumes[i].id),
                  onDelete: () => _confirmDelete(context, ref, resumes[i].id),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createResume(context, ref, user?.id ?? ''),
        icon: const Icon(Icons.add),
        label: const Text('New Resume'),
      ),
    );
  }

  Future<void> _createResume(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    final titleController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Resume'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Resume Title',
            hintText: 'e.g. Software Engineer',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    final title = titleController.text.trim();
    if (title.isEmpty) return;

    final resume = buildEmptyResume(userId, title);
    final result = await ref.read(createResumeProvider).call(CreateResumeParams(resume));
    if (!context.mounted) return;

    result.fold(
      (f) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(f.message))),
      (r) => context.pushNamed(
        RouteNames.resumeEditor,
        pathParameters: {'resumeId': r.id},
      ),
    );
  }

  Future<void> _duplicateResume(
    BuildContext context,
    WidgetRef ref,
    String resumeId,
  ) async {
    final result = await ref
        .read(duplicateResumeProvider)
        .call(DuplicateResumeParams(resumeId));

    if (!context.mounted) return;

    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(f.message)),
      ),
      (r) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resume duplicated: ${r.title}'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => context.pushNamed(
                RouteNames.resumeEditor,
                pathParameters: {'resumeId': r.id},
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String resumeId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Resume'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(deleteResumeProvider).call(DeleteResumeParams(resumeId));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateTap});
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.description_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const Gap(16),
            Text('No resumes yet', style: theme.textTheme.titleLarge),
            const Gap(8),
            Text(
              'Create your first ATS-optimized resume.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(24),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('Create Resume'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({
    required this.resume,
    required this.onTap,
    required this.onAnalyze,
    required this.onDuplicate,
    required this.onDelete,
  });

  final ResumeEntity resume;
  final VoidCallback onTap;
  final VoidCallback onAnalyze;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
        onTap: onTap,
        title: Text(resume.title, style: theme.textTheme.titleMedium),
        subtitle: Text(
          'Updated ${_formatDate(resume.updatedAt)}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ATS shortcut — most frequent action, stays visible
            IconButton(
              icon: const Icon(Icons.analytics_outlined),
              tooltip: 'ATS Analysis',
              onPressed: onAnalyze,
            ),
            // Overflow menu for less-frequent actions
            PopupMenuButton<_CardAction>(
              onSelected: (action) => switch (action) {
                _CardAction.duplicate => onDuplicate(),
                _CardAction.delete => onDelete(),
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: _CardAction.duplicate,
                  child: ListTile(
                    leading: Icon(Icons.copy_outlined),
                    title: Text('Duplicate'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                PopupMenuItem(
                  value: _CardAction.delete,
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

enum _CardAction { duplicate, delete }
