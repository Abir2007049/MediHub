import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_text_field.dart';

class DoctorRegistrationStep2Form extends StatelessWidget {
  const DoctorRegistrationStep2Form({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.submitButtonFocusNode,
    required this.loading,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onContinue,
    super.key,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final FocusNode submitButtonFocusNode;
  final bool loading;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          labelText: 'Password',
          hintText: '••••••••',
          obscureText: obscurePassword,
          onToggleObscure: onTogglePassword,
          helperText:
              'At least 8 characters with uppercase, lowercase, and number',
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          labelText: 'Confirm Password',
          hintText: '••••••••',
          obscureText: obscureConfirmPassword,
          onToggleObscure: onToggleConfirmPassword,
          helperText: 'Passwords must match',
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 32),
        Semantics(
          button: true,
          enabled: !loading,
          onTap: onContinue,
          label: 'Continue to Credentials',
          child: FilledButton(
            focusNode: submitButtonFocusNode,
            onPressed: loading ? null : onContinue,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Continue to Credentials"),
          ),
        ),
      ],
    );
  }
}
