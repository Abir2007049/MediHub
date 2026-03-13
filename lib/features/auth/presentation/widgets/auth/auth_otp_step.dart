import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';

class AuthOtpStep extends StatelessWidget {
  const AuthOtpStep({
    required this.otpFocusNode,
    required this.submitButtonFocus,
    required this.otpController,
    required this.formattedPhone,
    required this.loading,
    required this.onVerifyOtp,
    required this.textTheme,
    super.key,
  });

  final FocusNode otpFocusNode;
  final FocusNode submitButtonFocus;
  final TextEditingController otpController;
  final String formattedPhone;
  final bool loading;
  final VoidCallback onVerifyOtp;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Enter Verification Code',
            style: textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'A 6-digit code has been sent to $formattedPhone',
          child: Text(
            'A 6-digit code has been sent to $formattedPhone',
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 32),
        AppTextField(
          controller: otpController,
          focusNode: otpFocusNode,
          labelText: 'Verification Code',
          hintText: '000000',
          prefixIcon: Icons.shield,
          keyboardType: TextInputType.number,
          maxLength: 6,
          helperText: 'Enter the 6-digit code sent to your phone',
          onSubmitted: (_) => onVerifyOtp(),
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'Verify Code',
          focusNode: submitButtonFocus,
          onPressed: loading ? null : onVerifyOtp,
          isLoading: loading,
        ),
      ],
    );
  }
}
