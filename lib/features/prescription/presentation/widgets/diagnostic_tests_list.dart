import 'package:flutter/material.dart';
import 'package:medihub/features/prescription/presentation/widgets/medicines_list.dart';

class DiagnosticTestsList extends StatelessWidget {
  final List<String> tests;

  const DiagnosticTestsList({super.key, required this.tests});

  @override
  Widget build(BuildContext context) {
    if (tests.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Diagnostic Tests'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tests
              .map(
                (t) => Chip(
                  label: Text(t),
                  backgroundColor: colorScheme.secondaryContainer.withOpacity(
                    0.3,
                  ),
                  side: BorderSide(color: colorScheme.outlineVariant),
                  elevation: 0,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
