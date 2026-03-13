import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';

class AuthPhoneStep extends StatelessWidget {
  const AuthPhoneStep({
    required this.phoneFocusNode,
    required this.submitButtonFocus,
    required this.phoneController,
    required this.loading,
    required this.onSendOtp,
    required this.textTheme,
    super.key,
  });

  final FocusNode phoneFocusNode;
  final FocusNode submitButtonFocus;
  final TextEditingController phoneController;
  final bool loading;
  final VoidCallback onSendOtp;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          label: 'Enter your phone number',
          enabled: true,
          child: Text(
            'Enter Your Phone Number',
            style: textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'We will send you a verification code',
          enabled: true,
          child: Text(
            'We\'ll send you a verification code',
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 32),
        AppTextField(
          controller: phoneController,
          focusNode: phoneFocusNode,
          labelText: 'Phone Number',
          hintText: '01XXXXXXXXX',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          helperText: 'Bangladesh phone number (11 digits starting with 01)',
          onSubmitted: (_) => onSendOtp(),
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'Send Verification Code',
          focusNode: submitButtonFocus,
          onPressed: loading ? null : onSendOtp,
          isLoading: loading,
        ),
      ],
    );
  }
}
