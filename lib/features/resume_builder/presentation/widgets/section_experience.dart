import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_card.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';

class SectionExperience extends StatelessWidget {
  const SectionExperience({
    super.key,
    required this.experiences,
    required this.onChanged,
  });

  final List<ExperienceEntity> experiences;
  final ValueChanged<List<ExperienceEntity>> onChanged;

  void _add() => onChanged([
        ...experiences,
        ExperienceEntity(
          id: const Uuid().v4(),
          company: '',
          role: '',
          startDate: '',
          bullets: const [],
        ),
      ]);

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Work Experience',
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add experience',
          onPressed: _add,
        ),
        child: experiences.isEmpty
            ? _EmptyHint(label: 'No experience added yet.', onAdd: _add)
            : Column(
                children: experiences
                    .asMap()
                    .entries
                    .map(
                      (e) => _ExperienceItem(
                        key: ValueKey(e.value.id),
                        experience: e.value,
                        onChanged: (updated) {
                          final list = [...experiences];
                          list[e.key] = updated;
                          onChanged(list);
                        },
                        onDelete: () =>
                            onChanged([...experiences]..removeAt(e.key)),
                      ),
                    )
                    .toList(),
              ),
      );
}

class _ExperienceItem extends StatefulWidget {
  const _ExperienceItem({
    super.key,
    required this.experience,
    required this.onChanged,
    required this.onDelete,
  });

  final ExperienceEntity experience;
  final ValueChanged<ExperienceEntity> onChanged;
  final VoidCallback onDelete;

  @override
  State<_ExperienceItem> createState() => _ExperienceItemState();
}

class _ExperienceItemState extends State<_ExperienceItem> {
  late final _company = TextEditingController(text: widget.experience.company);
  late final _role = TextEditingController(text: widget.experience.role);
  late final _start = TextEditingController(text: widget.experience.startDate);
  late final _end = TextEditingController(text: widget.experience.endDate);

  @override
  void dispose() {
    _company.dispose();
    _role.dispose();
    _start.dispose();
    _end.dispose();
    super.dispose();
  }

  ExperienceEntity _current({List<String>? bullets}) => ExperienceEntity(
        id: widget.experience.id,
        company: _company.text,
        role: _role.text,
        startDate: _start.text,
        endDate: _end.text.isEmpty ? null : _end.text,
        isCurrent: _end.text.isEmpty,
        bullets: bullets ?? widget.experience.bullets,
      );

  void _notify() => widget.onChanged(_current());

  void _addBullet() => widget.onChanged(
        _current(bullets: [...widget.experience.bullets, '']),
      );

  void _updateBullet(int index, String value) {
    final bullets = [...widget.experience.bullets];
    bullets[index] = value;
    widget.onChanged(_current(bullets: bullets));
  }

  void _deleteBullet(int index) {
    final bullets = [...widget.experience.bullets]..removeAt(index);
    widget.onChanged(_current(bullets: bullets));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bullets = widget.experience.bullets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row: company + delete ────────────────────────────────
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Company',
                controller: _company,
                onChanged: (_) => _notify(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline,
                  color: theme.colorScheme.error,),
              tooltip: 'Remove experience',
              onPressed: widget.onDelete,
            ),
          ],
        ),
        const Gap(8),
        AppTextField(
          label: 'Role / Title',
          controller: _role,
          onChanged: (_) => _notify(),
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Start (e.g. Jan 2022)',
                controller: _start,
                onChanged: (_) => _notify(),
              ),
            ),
            const Gap(8),
            Expanded(
              child: AppTextField(
                label: 'End (or leave blank)',
                controller: _end,
                hint: 'Present',
                onChanged: (_) => _notify(),
              ),
            ),
          ],
        ),

        // ── Bullet points ─────────────────────────────────────────────
        const Gap(12),
        Row(
          children: [
            Text(
              'Achievements / Responsibilities',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addBullet,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add bullet'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        if (bullets.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Add bullet points to describe your achievements.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...bullets.asMap().entries.map(
                (e) => _BulletField(
                  key: ValueKey('${widget.experience.id}_bullet_${e.key}'),
                  index: e.key,
                  value: e.value,
                  onChanged: (v) => _updateBullet(e.key, v),
                  onDelete: () => _deleteBullet(e.key),
                ),
              ),

        const Gap(4),
        const Divider(),
        const Gap(8),
      ],
    );
  }
}

class _BulletField extends StatefulWidget {
  const _BulletField({
    super.key,
    required this.index,
    required this.value,
    required this.onChanged,
    required this.onDelete,
  });

  final int index;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;

  @override
  State<_BulletField> createState() => _BulletFieldState();
}

class _BulletFieldState extends State<_BulletField> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('•', style: TextStyle(fontSize: 18)),
            const Gap(8),
            Expanded(
              child: AppTextField(
                controller: _controller,
                label: 'Bullet point ${widget.index + 1}',
                hint: 'e.g. Led a team of 5 engineers to deliver X feature',
                maxLines: 2,
                onChanged: widget.onChanged,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: 'Remove bullet',
              onPressed: widget.onDelete,
            ),
          ],
        ),
      );
}

// ─── Shared empty hint widget ─────────────────────────────────────────────────

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
