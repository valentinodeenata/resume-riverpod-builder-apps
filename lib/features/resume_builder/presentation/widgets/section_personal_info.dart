import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:resume_riverpod_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_card.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';

class SectionPersonalInfo extends StatefulWidget {
  const SectionPersonalInfo({
    super.key,
    required this.info,
    required this.onChanged,
  });

  final PersonalInfoEntity info;
  final ValueChanged<PersonalInfoEntity> onChanged;

  @override
  State<SectionPersonalInfo> createState() => _SectionPersonalInfoState();
}

class _SectionPersonalInfoState extends State<SectionPersonalInfo> {
  late final TextEditingController _name = TextEditingController(text: widget.info.fullName);
  late final TextEditingController _email = TextEditingController(text: widget.info.email);
  late final TextEditingController _phone = TextEditingController(text: widget.info.phone);
  late final TextEditingController _location = TextEditingController(text: widget.info.location);
  late final TextEditingController _linkedin = TextEditingController(text: widget.info.linkedIn);
  late final TextEditingController _website = TextEditingController(text: widget.info.website);

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _location, _linkedin, _website]) {
      c.dispose();
    }
    super.dispose();
  }

  void _notify() => widget.onChanged(PersonalInfoEntity(
        fullName: _name.text,
        email: _email.text,
        phone: _phone.text,
        location: _location.text,
        linkedIn: _linkedin.text.isEmpty ? null : _linkedin.text,
        website: _website.text.isEmpty ? null : _website.text,
      ),
    );

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Personal Info',
        child: Column(
          children: [
            AppTextField(label: 'Full Name', controller: _name, onChanged: (_) => _notify()),
            const Gap(12),
            Row(
              children: [
                Expanded(child: AppTextField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress, onChanged: (_) => _notify())),
                const Gap(12),
                Expanded(child: AppTextField(label: 'Phone', controller: _phone, keyboardType: TextInputType.phone, onChanged: (_) => _notify())),
              ],
            ),
            const Gap(12),
            AppTextField(label: 'Location', controller: _location, onChanged: (_) => _notify()),
            const Gap(12),
            AppTextField(label: 'LinkedIn URL (optional)', controller: _linkedin, onChanged: (_) => _notify()),
            const Gap(12),
            AppTextField(label: 'Website (optional)', controller: _website, onChanged: (_) => _notify()),
          ],
        ),
      );
}
