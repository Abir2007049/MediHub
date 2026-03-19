import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.onToggleObscure,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.helperText,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final String? helperText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final resolvedPrefixIcon = prefixIcon ?? (obscureText ? Icons.lock : null);
    final colorScheme = Theme.of(context).colorScheme;
    const noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      // borderSide: BorderSide.none,
    );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      maxLength: maxLength,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: noBorder,
        enabledBorder: noBorder,
        focusedBorder: noBorder,
        disabledBorder: noBorder,
        errorBorder: noBorder,
        focusedErrorBorder: noBorder,
        prefixIcon: resolvedPrefixIcon != null
            ? Icon(resolvedPrefixIcon)
            : null,
        suffixIcon: onToggleObscure != null
            ? IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                tooltip: obscureText ? 'Show password' : 'Hide password',
              )
            : null,
      ),
    );
  }
}
