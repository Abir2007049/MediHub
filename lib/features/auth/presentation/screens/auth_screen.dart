import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/app_error_banner.dart';
import '../../../../core/widgets/app_step_indicator.dart';
import '../../../../models/patient_profile.dart';
import '../widgets/auth/auth_name_step.dart';
import '../widgets/auth/auth_otp_step.dart';
import '../widgets/auth/auth_phone_step.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = sl<SupabaseAuthService>();

  /// Steps: 0 = phone input, 1 = OTP verification, 2 = name (new user)
  int _step = 0;
  bool _loading = false;

  late final TextEditingController _phoneController;
  late final TextEditingController _otpController;
  late final TextEditingController _nameController;

  String _formattedPhone = '';
  String _errorMessage = '';

  late final FocusNode _phoneFocusNode;
  late final FocusNode _otpFocusNode;
  late final FocusNode _nameFocusNode;
  late final FocusNode _submitButtonFocus;

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
      body: SingleChildScrollView(
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
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(28),
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
              AppStepIndicator(
                currentStep: _step + 1,
                totalSteps: 3,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 40),

              // Error Message
              if (_errorMessage.isNotEmpty)
                AppErrorBanner(
                  message: _errorMessage,
                  colorScheme: colorScheme,
                ),
              if (_errorMessage.isNotEmpty) const SizedBox(height: 24),

              // Step Forms
              if (_step == 0)
                AuthPhoneStep(
                  phoneFocusNode: _phoneFocusNode,
                  submitButtonFocus: _submitButtonFocus,
                  phoneController: _phoneController,
                  loading: _loading,
                  onSendOtp: _sendOtp,
                  textTheme: textTheme,
                ),
              if (_step == 1)
                AuthOtpStep(
                  otpFocusNode: _otpFocusNode,
                  submitButtonFocus: _submitButtonFocus,
                  otpController: _otpController,
                  formattedPhone: _formattedPhone,
                  loading: _loading,
                  onVerifyOtp: _verifyOtp,
                  textTheme: textTheme,
                ),
              if (_step == 2)
                AuthNameStep(
                  nameFocusNode: _nameFocusNode,
                  submitButtonFocus: _submitButtonFocus,
                  nameController: _nameController,
                  loading: _loading,
                  onSaveProfile: _saveProfile,
                  textTheme: textTheme,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
