import 'package:flutter/material.dart';

class AppErrorBanner extends StatelessWidget {
  const AppErrorBanner({
    required this.message,
    required this.colorScheme,
    super.key,
  });

  final String message;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      enabled: true,
      label: 'Error message: $message',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.error.withAlpha(26),
          border: Border.all(color: colorScheme.error, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
