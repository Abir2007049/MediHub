import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_text_field.dart';

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
        Semantics(
          button: true,
          enabled: !loading,
          onTap: onSaveProfile,
          label: 'Complete Profile',
          child: FilledButton(
            focusNode: submitButtonFocus,
            onPressed: loading ? null : onSaveProfile,
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
                : const Text("Complete Profile"),
          ),
        ),
      ],
    );
  }
}
