import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../blocs/auth/auth_cubit.dart';
import '../models/patient_profile.dart';
import '../services/supabase_auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = SupabaseAuthService.instance;

  /// Steps: 0 = phone input, 1 = OTP verification, 2 = name (new user)
  int _step = 0;
  bool _loading = false;

  late TextEditingController _phoneController;
  late TextEditingController _otpController;
  late TextEditingController _nameController;

  String _formattedPhone = '';
  String _errorMessage = '';

  late FocusNode _phoneFocusNode;
  late FocusNode _otpFocusNode;
  late FocusNode _nameFocusNode;
  late FocusNode _submitButtonFocus;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
    _nameController = TextEditingController();

    _phoneFocusNode = FocusNode();
    _otpFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    _submitButtonFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _announceStep();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _phoneFocusNode.dispose();
    _otpFocusNode.dispose();
    _nameFocusNode.dispose();
    _submitButtonFocus.dispose();
    super.dispose();
  }

  void _announceStep() {
    String announcement = '';
    switch (_step) {
      case 0:
        announcement = 'Step 1 of 3: Enter your phone number';
        break;
      case 1:
        announcement =
            'Step 2 of 3: Enter the 6-digit verification code sent to $_formattedPhone';
        break;
      case 2:
        announcement = 'Step 3 of 3: Enter your full name';
        break;
    }
    _announceFeedback(announcement);
  }

  String _toE164(String local) {
    final digits = local.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      return '+88';
    }
    if (digits.startsWith('880')) {
      return '+';
    }
    return '+880';
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();

    setState(() => _errorMessage = '');

    if (phone.isEmpty) {
      setState(() => _errorMessage = 'Please enter your mobile number');
      _announceFeedback('Error: Please enter your mobile number');
      return;
    }

    if (phone.length != 11 || !phone.startsWith('01')) {
      setState(
        () =>
            _errorMessage = 'Mobile number must be 11 digits starting with 01',
      );
      _announceFeedback(
        'Error: Mobile number must be 11 digits starting with 01',
      );
      return;
    }

    _formattedPhone = _toE164(phone);

    setState(() => _loading = true);
    try {
      await _auth.sendOtp(phone: _formattedPhone);
      setState(() => _step = 1);
      _announceFeedback(
        'OTP sent successfully to $_formattedPhone. Check your messages.',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpFocusNode.requestFocus();
        _announceStep();
      });
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
      _announceFeedback('Error: ');
    } catch (e) {
      setState(() => _errorMessage = 'Failed to send OTP. Please try again.');
      _announceFeedback('Error: Failed to send OTP. Please try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final token = _otpController.text.trim();

    setState(() => _errorMessage = '');

    if (token.isEmpty || token.length != 6) {
      setState(() => _errorMessage = 'Please enter the 6-digit code');
      _announceFeedback('Error: Please enter the 6-digit code');
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await _auth.verifyOtp(
        phone: _formattedPhone,
        token: token,
      );

      final user = response.user;
      if (user == null) {
        setState(() => _errorMessage = 'Verification failed');
        _announceFeedback('Error: Verification failed');
        return;
      }

      final profile = await _auth.getPatientProfile(user.id);

      if (profile != null && profile['full_name'] != null) {
        _announceFeedback('Verification successful. Welcome back!');
        if (mounted) {
          context.read<AuthCubit>().setPatientAuthenticated(
            PatientProfile.fromJson(profile),
          );
          context.go('/patient');
        }
      } else {
        setState(() => _step = 2);
        _announceFeedback('Verification successful. Now enter your name.');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _nameFocusNode.requestFocus();
          _announceStep();
        });
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
      _announceFeedback('Error: ');
    } catch (e) {
      setState(() => _errorMessage = 'Verification failed. Please try again.');
      _announceFeedback('Error: Verification failed. Please try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();

    setState(() => _errorMessage = '');

    if (name.isEmpty || name.length < 2) {
      setState(() => _errorMessage = 'Please enter your full name');
      _announceFeedback('Error: Please enter your full name');
      return;
    }

    setState(() => _loading = true);
    try {
      final user = _auth.currentUser!;
      await _auth.upsertPatientProfile(
        userId: user.id,
        fullName: name,
        phone: _phoneController.text.trim(),
      );

      _announceFeedback('Welcome, $name! Your profile has been created.');
      if (mounted) {
        final freshProfile = await _auth.getPatientProfile(user.id);
        if (freshProfile != null && mounted) {
          context.read<AuthCubit>().setPatientAuthenticated(
            PatientProfile.fromJson(freshProfile),
          );
        }
        if (mounted) context.go('/patient');
      }
    } catch (e) {
      setState(
        () => _errorMessage = 'Failed to save profile. Please try again.',
      );
      _announceFeedback('Error: Failed to save profile. Please try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _announceFeedback(String message) {
    if (!mounted) return;
    final view = View.of(context);
    SemanticsService.sendAnnouncement(view, message, TextDirection.ltr);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          button: true,
          enabled: true,
          label: 'Go back',
          onTap: () => _step > 0
              ? setState(() {
                  _step--;
                  _errorMessage = '';
                  _announceStep();
                })
              : context.pop(),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 28,
            onPressed: () => _step > 0
                ? setState(() {
                    _step--;
                    _errorMessage = '';
                    _announceStep();
                  })
                : context.pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Logo
                Semantics(
                  image: true,
                  label: 'MediHub logo',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(50),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_hospital,
                      size: 40,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Semantics(
                  header: true,
                  child: Text('Patient Sign In', style: textTheme.displaySmall),
                ),
                const SizedBox(height: 16),

                // Step Indicator
                _buildAccessibleStepIndicator(colorScheme),
                const SizedBox(height: 40),

                // Error Message
                if (_errorMessage.isNotEmpty)
                  _buildErrorWidget(_errorMessage, colorScheme),
                if (_errorMessage.isNotEmpty) const SizedBox(height: 24),

                // Step Forms
                if (_step == 0) _buildPhoneStep(colorScheme, textTheme),
                if (_step == 1) _buildOtpStep(colorScheme, textTheme),
                if (_step == 2) _buildNameStep(colorScheme, textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibleStepIndicator(ColorScheme colorScheme) {
    return Semantics(
      label: 'Step indicator: Step ${_step + 1} of 3',
      enabled: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final isActive = i <= _step;
          return Expanded(
            child: Row(
              children: [
                Semantics(
                  label: 'Step ${i + 1}, ${isActive ? "completed" : "pending"}',
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
                        '${i + 1}',
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
                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: i < _step
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

  Widget _buildPhoneStep(ColorScheme colorScheme, TextTheme textTheme) {
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
        _buildAccessibleTextField(
          focusNode: _phoneFocusNode,
          controller: _phoneController,
          labelText: 'Phone Number',
          hintText: '01XXXXXXXXX',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          helperText: 'Bangladesh phone number (11 digits starting with 01)',
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 32),
        _buildAccessibleButton(
          focusNode: _submitButtonFocus,
          label: 'Send Verification Code',
          onPressed: _loading ? null : _sendOtp,
          isLoading: _loading,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _buildOtpStep(ColorScheme colorScheme, TextTheme textTheme) {
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
          label: 'A 6-digit code has been sent to $_formattedPhone',
          child: Text(
            'A 6-digit code has been sent to $_formattedPhone',
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 32),
        _buildAccessibleTextField(
          focusNode: _otpFocusNode,
          controller: _otpController,
          labelText: 'Verification Code',
          hintText: '000000',
          prefixIcon: Icons.shield,
          keyboardType: TextInputType.number,
          maxLength: 6,
          helperText: 'Enter the 6-digit code sent to your phone',
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 32),
        _buildAccessibleButton(
          focusNode: _submitButtonFocus,
          label: 'Verify Code',
          onPressed: _loading ? null : _verifyOtp,
          isLoading: _loading,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _buildNameStep(ColorScheme colorScheme, TextTheme textTheme) {
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
        _buildAccessibleTextField(
          focusNode: _nameFocusNode,
          controller: _nameController,
          labelText: 'Full Name',
          hintText: 'John Doe',
          prefixIcon: Icons.person,
          keyboardType: TextInputType.name,
          helperText: 'Your full name will appear on your profile',
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 32),
        _buildAccessibleButton(
          focusNode: _submitButtonFocus,
          label: 'Complete Profile',
          onPressed: _loading ? null : _saveProfile,
          isLoading: _loading,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message, ColorScheme colorScheme) {
    return Semantics(
      enabled: true,
      label: 'Error message: $message',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.error.withAlpha(26),
          border: Border.all(color: colorScheme.error, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibleTextField({
    required FocusNode focusNode,
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? helperText,
  }) {
    return Semantics(
      enabled: true,
      textField: true,
      label: labelText,
      onTap: () => focusNode.requestFocus(),
      child: Focus(
        focusNode: focusNode,
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            if (_step == 0) _sendOtp();
            if (_step == 1) _verifyOtp();
            if (_step == 2) _saveProfile();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Builder(
          builder: (context) {
            final isFocused = Focus.of(context).hasFocus;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  textInputAction: TextInputAction.next,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: labelText,
                    hintText: hintText,
                    prefixIcon: Icon(
                      prefixIcon,
                      color: isFocused
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                ),
                if (helperText != null) ...[
                  const SizedBox(height: 8),
                  Semantics(
                    label: helperText,
                    enabled: true,
                    child: Text(helperText, style: textTheme.labelMedium),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccessibleButton({
    required FocusNode focusNode,
    required String label,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    bool isLoading = false,
  }) {
    final isEnabled = onPressed != null && !isLoading;

    return Semantics(
      button: true,
      enabled: isEnabled,
      onTap: onPressed,
      label: label,
      child: Focus(
        focusNode: focusNode,
        onKeyEvent: (node, event) {
          if (isEnabled &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            onPressed();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: GestureDetector(
          onTap: isEnabled ? onPressed : null,
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isEnabled
                      ? LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: !isEnabled
                      ? colorScheme.surfaceContainerHighest
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  border: isFocused
                      ? Border.all(color: colorScheme.primary, width: 3)
                      : null,
                  boxShadow: isEnabled
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withAlpha(77),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          label,
                          style: textTheme.labelLarge?.copyWith(
                            color: isEnabled
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
