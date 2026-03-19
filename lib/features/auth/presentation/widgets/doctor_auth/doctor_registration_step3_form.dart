import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_text_field.dart';

class DoctorRegistrationStep3Form extends StatelessWidget {
  const DoctorRegistrationStep3Form({
    required this.specializationController,
    required this.hospitalController,
    required this.departmentController,
    required this.degreeController,
    required this.collegeController,
    required this.specializationFocusNode,
    required this.hospitalFocusNode,
    required this.departmentFocusNode,
    required this.degreeFocusNode,
    required this.collegeFocusNode,
    required this.submitButtonFocusNode,
    required this.loading,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController specializationController;
  final TextEditingController hospitalController;
  final TextEditingController departmentController;
  final TextEditingController degreeController;
  final TextEditingController collegeController;

  final FocusNode specializationFocusNode;
  final FocusNode hospitalFocusNode;
  final FocusNode departmentFocusNode;
  final FocusNode degreeFocusNode;
  final FocusNode collegeFocusNode;
  final FocusNode submitButtonFocusNode;

  final bool loading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: specializationController,
          focusNode: specializationFocusNode,
          labelText: 'Specialization',
          hintText: 'Cardiology',
          prefixIcon: Icons.medical_services,
          helperText: 'Your primary area of specialization',
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: hospitalController,
          focusNode: hospitalFocusNode,
          labelText: 'Hospital/Clinic Name',
          hintText: 'ABC Medical Center',
          prefixIcon: Icons.local_hospital,
          helperText: 'Current or primary hospital/clinic affiliation',
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: departmentController,
          focusNode: departmentFocusNode,
          labelText: 'Department',
          hintText: 'Cardiology Department',
          prefixIcon: Icons.category,
          helperText: 'Your department at the hospital/clinic',
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: degreeController,
          focusNode: degreeFocusNode,
          labelText: 'Highest Degree',
          hintText: 'MBBS, MD Cardiology',
          prefixIcon: Icons.school,
          helperText: 'Your highest medical degree',
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: collegeController,
          focusNode: collegeFocusNode,
          labelText: 'Medical College',
          hintText: 'Medical College',
          prefixIcon: Icons.local_hospital,
          helperText: 'Medical college where you graduated',
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 32),
        Semantics(
          button: true,
          enabled: !loading,
          onTap: onSubmit,
          label: 'Complete Registration',
          child: FilledButton(
            focusNode: submitButtonFocusNode,
            onPressed: loading ? null : onSubmit,
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
                : const Text("Complete Registration"),
          ),
        ),
      ],
    );
  }
}
