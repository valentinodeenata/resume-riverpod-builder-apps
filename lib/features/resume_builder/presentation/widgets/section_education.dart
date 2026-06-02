import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_card.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';

class SectionEducation extends StatelessWidget {
  const SectionEducation({
    super.key,
    required this.educations,
    required this.onChanged,
  });

  final List<EducationEntity> educations;
  final ValueChanged<List<EducationEntity>> onChanged;

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Education',
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged([
            ...educations,
            EducationEntity(
              id: const Uuid().v4(),
              institution: '',
              degree: '',
              fieldOfStudy: '',
              startYear: '',
            ),
          ]),
        ),
        child: educations.isEmpty
            ? const Text('No education added yet.')
            : Column(
                children: educations
                    .asMap()
                    .entries
                    .map(
                      (e) => _EducationItem(
                        education: e.value,
                        onChanged: (updated) {
                          final list = [...educations];
                          list[e.key] = updated;
                          onChanged(list);
                        },
                        onDelete: () => onChanged([...educations]..removeAt(e.key)),
                      ),
                    )
                    .toList(),
              ),
      );
}

class _EducationItem extends StatefulWidget {
  const _EducationItem({
    required this.education,
    required this.onChanged,
    required this.onDelete,
  });

  final EducationEntity education;
  final ValueChanged<EducationEntity> onChanged;
  final VoidCallback onDelete;

  @override
  State<_EducationItem> createState() => _EducationItemState();
}

class _EducationItemState extends State<_EducationItem> {
  late final _institution = TextEditingController(text: widget.education.institution);
  late final _degree = TextEditingController(text: widget.education.degree);
  late final _field = TextEditingController(text: widget.education.fieldOfStudy);
  late final _start = TextEditingController(text: widget.education.startYear);
  late final _end = TextEditingController(text: widget.education.endYear);
  late final _gpa = TextEditingController(text: widget.education.gpa);

  @override
  void dispose() {
    for (final c in [_institution, _degree, _field, _start, _end, _gpa]) {
      c.dispose();
    }
    super.dispose();
  }

  void _notify() => widget.onChanged(EducationEntity(
        id: widget.education.id,
        institution: _institution.text,
        degree: _degree.text,
        fieldOfStudy: _field.text,
        startYear: _start.text,
        endYear: _end.text.isEmpty ? null : _end.text,
        gpa: _gpa.text.isEmpty ? null : _gpa.text,
      ),
    );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppTextField(label: 'Institution', controller: _institution, onChanged: (_) => _notify())),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          const Gap(8),
          AppTextField(label: 'Degree', controller: _degree, onChanged: (_) => _notify()),
          const Gap(8),
          AppTextField(label: 'Field of Study', controller: _field, onChanged: (_) => _notify()),
          const Gap(8),
          Row(
            children: [
              Expanded(child: AppTextField(label: 'Start Year', controller: _start, onChanged: (_) => _notify())),
              const Gap(8),
              Expanded(child: AppTextField(label: 'End Year', controller: _end, onChanged: (_) => _notify())),
              const Gap(8),
              Expanded(child: AppTextField(label: 'GPA (opt.)', controller: _gpa, onChanged: (_) => _notify())),
            ],
          ),
          const Gap(8),
          const Divider(),
          const Gap(4),
        ],
      );
}
