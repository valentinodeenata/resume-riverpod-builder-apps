import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_card.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';

class SectionCertifications extends StatelessWidget {
  const SectionCertifications({
    super.key,
    required this.certifications,
    required this.onChanged,
  });

  final List<CertificationEntity> certifications;
  final ValueChanged<List<CertificationEntity>> onChanged;

  void _add() => onChanged([
        ...certifications,
        CertificationEntity(
          id: const Uuid().v4(),
          name: '',
          issuer: '',
          year: '',
        ),
      ]);

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Certifications',
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add certification',
          onPressed: _add,
        ),
        child: certifications.isEmpty
            ? _EmptyHint(label: 'No certifications added yet.', onAdd: _add)
            : Column(
                children: certifications
                    .asMap()
                    .entries
                    .map(
                      (e) => _CertificationItem(
                        key: ValueKey(e.value.id),
                        certification: e.value,
                        onChanged: (updated) {
                          final list = [...certifications];
                          list[e.key] = updated;
                          onChanged(list);
                        },
                        onDelete: () =>
                            onChanged([...certifications]..removeAt(e.key)),
                      ),
                    )
                    .toList(),
              ),
      );
}

class _CertificationItem extends StatefulWidget {
  const _CertificationItem({
    super.key,
    required this.certification,
    required this.onChanged,
    required this.onDelete,
  });

  final CertificationEntity certification;
  final ValueChanged<CertificationEntity> onChanged;
  final VoidCallback onDelete;

  @override
  State<_CertificationItem> createState() => _CertificationItemState();
}

class _CertificationItemState extends State<_CertificationItem> {
  late final _name = TextEditingController(text: widget.certification.name);
  late final _issuer = TextEditingController(text: widget.certification.issuer);
  late final _year = TextEditingController(text: widget.certification.year);

  @override
  void dispose() {
    _name.dispose();
    _issuer.dispose();
    _year.dispose();
    super.dispose();
  }

  void _notify() => widget.onChanged(CertificationEntity(
        id: widget.certification.id,
        name: _name.text,
        issuer: _issuer.text,
        year: _year.text,
      ),
    );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Certification Name',
                  controller: _name,
                  hint: 'e.g. AWS Certified Developer',
                  onChanged: (_) => _notify(),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                tooltip: 'Remove certification',
                onPressed: widget.onDelete,
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Issuer',
                  controller: _issuer,
                  hint: 'e.g. Amazon Web Services',
                  onChanged: (_) => _notify(),
                ),
              ),
              const Gap(8),
              SizedBox(
                width: 100,
                child: AppTextField(
                  label: 'Year',
                  controller: _year,
                  hint: '2024',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _notify(),
                ),
              ),
            ],
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
