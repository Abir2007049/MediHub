import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';

class DoctorLoginForm extends StatelessWidget {
  const DoctorLoginForm({
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.submitButtonFocusNode,
    required this.loading,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode submitButtonFocusNode;
  final bool loading;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: emailController,
          focusNode: emailFocusNode,
          labelText: 'Email Address',
          hintText: 'doctor@example.com',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          helperText: 'Enter your registered email address',
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          labelText: 'Password',
          hintText: '••••••••',
          obscureText: obscurePassword,
          onToggleObscure: onTogglePassword,
          helperText: 'Enter your password',
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 32),
        AppButton(
          focusNode: submitButtonFocusNode,
          label: 'Sign In',
          onPressed: loading ? null : onSubmit,
          isLoading: loading,
        ),
      ],
    );
  }
}
