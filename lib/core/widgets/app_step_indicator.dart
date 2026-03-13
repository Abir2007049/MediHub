import 'package:flutter/material.dart';

class AppStepIndicator extends StatelessWidget {
  const AppStepIndicator({
    required this.currentStep,
    required this.colorScheme,
    this.totalSteps = 3,
    super.key,
  });

  final int currentStep;
  final int totalSteps;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Progress: Step $currentStep of $totalSteps',
      enabled: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (i) {
          final stepNumber = i + 1;
          final isActive = stepNumber <= currentStep;
          return Expanded(
            child: Row(
              children: [
                Semantics(
                  label:
                      'Step $stepNumber, ${isActive ? 'completed' : 'pending'}',
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      border: Border.all(color: colorScheme.outline, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$stepNumber',
                        style: TextStyle(
                          color: isActive
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (i < totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: stepNumber < currentStep
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
