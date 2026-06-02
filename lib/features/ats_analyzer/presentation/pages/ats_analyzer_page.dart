import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:resume_riverpod_builder/features/ats_analyzer/domain/entities/ats_result_entity.dart';
import 'package:resume_riverpod_builder/features/ats_analyzer/presentation/providers/ats_provider.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_button.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_loading.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';
import 'package:resume_riverpod_builder/shared/widgets/error_view.dart';

class AtsAnalyzerPage extends ConsumerStatefulWidget {
  const AtsAnalyzerPage({super.key, required this.resumeId});
  final String resumeId;

  @override
  ConsumerState<AtsAnalyzerPage> createState() => _AtsAnalyzerPageState();
}

class _AtsAnalyzerPageState extends ConsumerState<AtsAnalyzerPage> {
  final _jdController = TextEditingController();
  bool _jdIsEmpty = true;

  @override
  void initState() {
    super.initState();
    _jdController.addListener(() {
      final empty = _jdController.text.trim().isEmpty;
      if (empty != _jdIsEmpty) setState(() => _jdIsEmpty = empty);
    });
  }

  @override
  void dispose() {
    _jdController.dispose();
    super.dispose();
  }

  void _analyze() {
    if (_jdController.text.trim().isEmpty) return;
    ref.read(atsNotifierProvider(widget.resumeId).notifier).analyze(_jdController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(atsNotifierProvider(widget.resumeId));
    final theme = Theme.of(context);
    final isLoading = state is AsyncLoading;

    ref.listen(atsNotifierProvider(widget.resumeId), (_, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('ATS Analysis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Paste Job Description',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(4),
          Text(
            'Paste the full job posting to get an accurate ATS score.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const Gap(12),
          AppTextField(
            controller: _jdController,
            label: 'Job Description',
            maxLines: 8,
            hint: 'Paste the full job posting here...',
          ),
          const Gap(16),
          AppButton(
            label: 'Analyze',
            isLoading: isLoading,
            onPressed: isLoading || _jdIsEmpty ? null : _analyze,
          ),
          if (_jdIsEmpty) ...[
            const Gap(8),
            Text(
              'Job description cannot be empty.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
            ),
          ],
          const Gap(24),
          state.when(
            loading: () => const AppLoadingCard(height: 200),
            error: (e, _) => ErrorView(message: e.toString()),
            data: (result) => result == null
                ? const SizedBox.shrink()
                : _AtsResultView(result: result),
          ),
        ],
      ),
    );
  }
}

class _AtsResultView extends StatelessWidget {
  const _AtsResultView({required this.result});
  final AtsResultEntity result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = result.score >= 80
        ? Colors.green
        : result.score >= 60
            ? Colors.orange
            : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text('ATS Score', style: theme.textTheme.titleMedium),
                const Gap(8),
                Text(
                  '${result.score}',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
                Text(result.scoreLabel, style: theme.textTheme.titleSmall?.copyWith(color: scoreColor)),
                const Gap(16),
                LinearProgressIndicator(
                  value: result.score / 100,
                  color: scoreColor,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(child: _SubScoreCard(label: 'Keywords', score: result.keywordScore)),
            const Gap(8),
            Expanded(child: _SubScoreCard(label: 'Format', score: result.formatScore)),
            const Gap(8),
            Expanded(child: _SubScoreCard(label: 'Sections', score: result.sectionScore)),
          ],
        ),
        if (result.missingKeywords.isNotEmpty) ...[
          const Gap(12),
          _IssueCard(
            title: 'Missing Keywords',
            items: result.missingKeywords,
            icon: Icons.label_off_outlined,
            color: Colors.orange,
          ),
        ],
        if (result.matchedKeywords.isNotEmpty) ...[
          const Gap(12),
          _IssueCard(
            title: 'Matched Keywords',
            items: result.matchedKeywords,
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
        ],
        if (result.formatIssues.isNotEmpty) ...[
          const Gap(12),
          _IssueCard(
            title: 'Format Issues',
            items: result.formatIssues,
            icon: Icons.warning_amber_outlined,
            color: Colors.red,
          ),
        ],
        if (result.missingSections.isNotEmpty) ...[
          const Gap(12),
          _IssueCard(
            title: 'Missing Sections',
            items: result.missingSections,
            icon: Icons.playlist_remove,
            color: Colors.red,
          ),
        ],
      ],
    );
  }
}

class _SubScoreCard extends StatelessWidget {
  const _SubScoreCard({required this.label, required this.score});
  final String label;
  final int score;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const Gap(4),
              Text(
                '$score',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 18),
                  const Gap(8),
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
              const Gap(8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: items
                    .map((item) => Chip(
                          label: Text(item, style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                        ),)
                    .toList(),
              ),
            ],
          ),
        ),
      );
}
