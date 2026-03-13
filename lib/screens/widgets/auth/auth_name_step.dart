import 'package:flutter/material.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class AuthNameStep extends StatelessWidget {
  const AuthNameStep({
    required this.nameFocusNode,
    required this.submitButtonFocus,
    required this.nameController,
    required this.loading,
    required this.onSaveProfile,
    required this.textTheme,
    super.key,
  });

  final FocusNode nameFocusNode;
  final FocusNode submitButtonFocus;
  final TextEditingController nameController;
  final bool loading;
  final VoidCallback onSaveProfile;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text('Create Your Profile', style: textTheme.headlineLarge),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Help us know who you are',
          child: Text('Help us know who you are', style: textTheme.bodyMedium),
        ),
        const SizedBox(height: 32),
        AppTextField(
          controller: nameController,
          focusNode: nameFocusNode,
          labelText: 'Full Name',
          hintText: 'John Doe',
          prefixIcon: Icons.person,
          keyboardType: TextInputType.name,
          helperText: 'Your full name will appear on your profile',
          onSubmitted: (_) => onSaveProfile(),
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'Complete Profile',
          focusNode: submitButtonFocus,
          onPressed: loading ? null : onSaveProfile,
          isLoading: loading,
        ),
      ],
    );
  }
}
