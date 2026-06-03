import 'package:flutter/material.dart';

/// Wraps [child] with a left-swipe-to-delete gesture.
///
/// Shows a red delete background when swiping, then calls [onDismissed].
class SwipeToDismissItem extends StatelessWidget {
  const SwipeToDismissItem({
    super.key,
    required this.dismissKey,
    required this.onDismissed,
    required this.child,
  });

  final Key dismissKey;
  final VoidCallback onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: dismissKey,
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Remove entry?'),
          content: const Text('This will remove the entry from your resume.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: const Text('Remove'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      child: child,
    );
  }
}
