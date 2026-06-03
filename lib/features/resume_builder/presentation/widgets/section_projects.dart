import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_card.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';
import 'package:resume_riverpod_builder/shared/widgets/swipe_to_dismiss_item.dart';

class SectionProjects extends StatelessWidget {
  const SectionProjects({
    super.key,
    required this.projects,
    required this.onChanged,
  });

  final List<ProjectEntity> projects;
  final ValueChanged<List<ProjectEntity>> onChanged;

  void _add() => onChanged([
        ...projects,
        ProjectEntity(
          id: const Uuid().v4(),
          name: '',
          description: '',
          techStack: const [],
        ),
      ]);

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Projects',
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add project',
          onPressed: _add,
        ),
        child: projects.isEmpty
            ? _EmptyHint(label: 'No projects added yet.', onAdd: _add)
            : Column(
                children: projects
                    .asMap()
                    .entries
                    .map(
                      (e) => SwipeToDismissItem(
                        key: ValueKey(e.value.id),
                        dismissKey: ValueKey('dismiss_proj_${e.value.id}'),
                        onDismissed: () => onChanged([...projects]..removeAt(e.key)),
                        child: _ProjectItem(
                          key: ValueKey(e.value.id),
                          project: e.value,
                          onChanged: (updated) {
                            final list = [...projects];
                            list[e.key] = updated;
                            onChanged(list);
                          },
                          onDelete: () =>
                              onChanged([...projects]..removeAt(e.key)),
                        ),
                      ),
                    )
                    .toList(),
              ),
      );
}

class _ProjectItem extends StatefulWidget {
  const _ProjectItem({
    super.key,
    required this.project,
    required this.onChanged,
    required this.onDelete,
  });

  final ProjectEntity project;
  final ValueChanged<ProjectEntity> onChanged;
  final VoidCallback onDelete;

  @override
  State<_ProjectItem> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<_ProjectItem> {
  late final _name = TextEditingController(text: widget.project.name);
  late final _desc = TextEditingController(text: widget.project.description);
  late final _tech = TextEditingController(
    text: widget.project.techStack.join(', '),
  );
  late final _url = TextEditingController(text: widget.project.url ?? '');

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _tech.dispose();
    _url.dispose();
    super.dispose();
  }

  void _notify() => widget.onChanged(ProjectEntity(
        id: widget.project.id,
        name: _name.text,
        description: _desc.text,
        techStack: _tech.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        url: _url.text.isEmpty ? null : _url.text,
      ),
    );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Project Name',
                  controller: _name,
                  onChanged: (_) => _notify(),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                tooltip: 'Remove project',
                onPressed: widget.onDelete,
              ),
            ],
          ),
          const Gap(8),
          AppTextField(
            label: 'Description',
            controller: _desc,
            maxLines: 3,
            hint: 'What does this project do and what impact did it have?',
            onChanged: (_) => _notify(),
          ),
          const Gap(8),
          AppTextField(
            label: 'Tech Stack (comma-separated)',
            controller: _tech,
            hint: 'Flutter, Dart, Firebase, ...',
            onChanged: (_) => _notify(),
          ),
          const Gap(8),
          AppTextField(
            label: 'URL (optional)',
            controller: _url,
            hint: 'https://github.com/...',
            keyboardType: TextInputType.url,
            onChanged: (_) => _notify(),
          ),
          const Gap(8),
          const Divider(),
          const Gap(8),
        ],
      );
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.label, required this.onAdd});

  final String label;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(8),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add'),
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}
