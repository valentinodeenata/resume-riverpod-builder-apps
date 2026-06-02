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

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Work Experience',
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged([
            ...experiences,
            ExperienceEntity(
              id: const Uuid().v4(),
              company: '',
              role: '',
              startDate: '',
              bullets: const [],
            ),
          ]),
        ),
        child: experiences.isEmpty
            ? const Text('No experience added yet.')
            : Column(
                children: experiences
                    .asMap()
                    .entries
                    .map(
                      (e) => _ExperienceItem(
                        experience: e.value,
                        onChanged: (updated) {
                          final list = [...experiences];
                          list[e.key] = updated;
                          onChanged(list);
                        },
                        onDelete: () {
                          final list = [...experiences]..removeAt(e.key);
                          onChanged(list);
                        },
                      ),
                    )
                    .toList(),
              ),
      );
}

class _ExperienceItem extends StatefulWidget {
  const _ExperienceItem({
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

  void _notify() => widget.onChanged(ExperienceEntity(
        id: widget.experience.id,
        company: _company.text,
        role: _role.text,
        startDate: _start.text,
        endDate: _end.text.isEmpty ? null : _end.text,
        bullets: widget.experience.bullets,
      ),
    );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppTextField(label: 'Company', controller: _company, onChanged: (_) => _notify())),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          const Gap(8),
          AppTextField(label: 'Role / Title', controller: _role, onChanged: (_) => _notify()),
          const Gap(8),
          Row(
            children: [
              Expanded(child: AppTextField(label: 'Start (e.g. Jan 2022)', controller: _start, onChanged: (_) => _notify())),
              const Gap(8),
              Expanded(child: AppTextField(label: 'End (or Present)', controller: _end, onChanged: (_) => _notify())),
            ],
          ),
          const Gap(8),
          const Divider(),
          const Gap(4),
        ],
      );
}
