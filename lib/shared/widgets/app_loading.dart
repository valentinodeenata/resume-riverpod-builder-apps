import 'package:flutter/material.dart';

/// Full-screen centered loading indicator.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}

/// Inline shimmer-style loading placeholder.
class AppLoadingCard extends StatelessWidget {
  const AppLoadingCard({super.key, this.height = 80});

  final double height;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
