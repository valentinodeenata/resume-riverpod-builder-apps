import 'package:flutter/material.dart';

import 'package:resume_riverpod_builder/features/resume_builder/presentation/widgets/section_card.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';

class SectionSummary extends StatefulWidget {
  const SectionSummary({
    super.key,
    required this.summary,
    required this.onChanged,
  });

  final String summary;
  final ValueChanged<String> onChanged;

  @override
  State<SectionSummary> createState() => _SectionSummaryState();
}

class _SectionSummaryState extends State<SectionSummary> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.summary);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SectionCard(
        title: 'Professional Summary',
        child: AppTextField(
          controller: _controller,
          label: 'Summary',
          maxLines: 4,
          hint: 'Write 2–4 sentences highlighting your top skills and experience...',
          onChanged: widget.onChanged,
        ),
      );
}
