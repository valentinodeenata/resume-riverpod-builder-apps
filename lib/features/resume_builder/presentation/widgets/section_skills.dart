import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_card.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';

class SectionSkills extends StatelessWidget {
  const SectionSkills({
    super.key,
    required this.skillGroups,
    required this.onChanged,
  });

  final List<SkillGroupEntity> skillGroups;
  final ValueChanged<List<SkillGroupEntity>> onChanged;

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Skills',
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged([
            ...skillGroups,
            SkillGroupEntity(id: const Uuid().v4(), category: '', skills: const []),
          ]),
        ),
        child: skillGroups.isEmpty
            ? const Text('No skills added yet.')
            : Column(
                children: skillGroups
                    .asMap()
                    .entries
                    .map(
                      (e) => _SkillGroupItem(
                        group: e.value,
                        onChanged: (updated) {
                          final list = [...skillGroups];
                          list[e.key] = updated;
                          onChanged(list);
                        },
                        onDelete: () => onChanged([...skillGroups]..removeAt(e.key)),
                      ),
                    )
                    .toList(),
              ),
      );
}

class _SkillGroupItem extends StatefulWidget {
  const _SkillGroupItem({
    required this.group,
    required this.onChanged,
    required this.onDelete,
  });

  final SkillGroupEntity group;
  final ValueChanged<SkillGroupEntity> onChanged;
  final VoidCallback onDelete;

  @override
  State<_SkillGroupItem> createState() => _SkillGroupItemState();
}

class _SkillGroupItemState extends State<_SkillGroupItem> {
  late final _category = TextEditingController(text: widget.group.category);
  late final _skills = TextEditingController(text: widget.group.skills.join(', '));

  @override
  void dispose() {
    _category.dispose();
    _skills.dispose();
    super.dispose();
  }

  void _notify() => widget.onChanged(SkillGroupEntity(
        id: widget.group.id,
        category: _category.text,
        skills: _skills.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
      ),
    );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Expanded(child: AppTextField(label: 'Category (e.g. Languages)', controller: _category, onChanged: (_) => _notify())),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          const Gap(8),
          AppTextField(
            label: 'Skills (comma-separated)',
            controller: _skills,
            hint: 'Flutter, Dart, Firebase, ...',
            onChanged: (_) => _notify(),
          ),
          const Gap(8),
          const Divider(),
          const Gap(4),
        ],
      );
}
