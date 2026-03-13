import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';

class DoctorRegistrationStep1Form extends StatelessWidget {
  const DoctorRegistrationStep1Form({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.nidController,
    required this.licenseController,
    required this.nameFocusNode,
    required this.emailFocusNode,
    required this.phoneFocusNode,
    required this.nidFocusNode,
    required this.licenseFocusNode,
    required this.submitButtonFocusNode,
    required this.loading,
    required this.onContinue,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController nidController;
  final TextEditingController licenseController;

  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode phoneFocusNode;
  final FocusNode nidFocusNode;
  final FocusNode licenseFocusNode;
  final FocusNode submitButtonFocusNode;

  final bool loading;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: nameController,
          focusNode: nameFocusNode,
          labelText: 'Full Name',
          hintText: 'Dr. John Doe',
          prefixIcon: Icons.person,
          keyboardType: TextInputType.name,
          helperText: 'Enter your full name as on BMDC certificate',
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: emailController,
          focusNode: emailFocusNode,
          labelText: 'Email Address',
          hintText: 'doctor@example.com',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          helperText: 'Use a professional email address',
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: phoneController,
          focusNode: phoneFocusNode,
          labelText: 'Phone Number',
          hintText: '01XXXXXXXXX',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          helperText: 'Bangladesh phone number (11 digits starting with 01)',
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: nidController,
          focusNode: nidFocusNode,
          labelText: 'NID Number',
          hintText: '12345678901234',
          prefixIcon: Icons.badge,
          keyboardType: TextInputType.number,
          maxLength: 17,
          helperText: 'Enter your 13 or 17-digit National ID number',
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: licenseController,
          focusNode: licenseFocusNode,
          labelText: 'BMDC License Number',
          hintText: 'A-12345',
          prefixIcon: Icons.card_travel,
          helperText: 'Enter your BMDC license number',
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 32),
        AppButton(
          focusNode: submitButtonFocusNode,
          label: 'Continue to Password',
          onPressed: loading ? null : onContinue,
          isLoading: loading,
        ),
      ],
    );
  }
}
