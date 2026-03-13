import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/services/bmdc_license_verification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/widgets/app_error_banner.dart';
import '../shared/widgets/app_step_indicator.dart';
import '../blocs/auth/auth_cubit.dart';
import '../services/supabase_auth_service.dart';
import 'widgets/doctor_auth/doctor_login_form.dart';
import 'widgets/doctor_auth/doctor_registration_step1_form.dart';
import 'widgets/doctor_auth/doctor_registration_step2_form.dart';
import 'widgets/doctor_auth/doctor_registration_step3_form.dart';

class DoctorAuthScreen extends StatefulWidget {
  const DoctorAuthScreen({super.key});

  @override
  State<DoctorAuthScreen> createState() => _DoctorAuthScreenState();
}

class _DoctorAuthScreenState extends State<DoctorAuthScreen> {
  final _auth = SupabaseAuthService.instance;

  bool _isLogin = true;
  int _registrationStep = 1; // 1-3 for registration
  bool _loading = false;

  late final TextEditingController _loginEmailController;
  late final TextEditingController _loginPasswordController;
  bool _obscureLoginPassword = true;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nidController;
  late final TextEditingController _licenseController;

  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late final TextEditingController _specializationController;
  late final TextEditingController _hospitalController;
  late final TextEditingController _departmentController;
  late final TextEditingController _degreeController;
  late final TextEditingController _medicalCollegeController;

  String _errorMessage = '';

  late final FocusNode _primaryFocusNode;
  late final FocusNode _secondaryFocusNode;
  late final FocusNode _submitButtonFocus;

  // Additional focus nodes for Step 1
  late final FocusNode _phoneFocusNode;
  late final FocusNode _nidFocusNode;
  late final FocusNode _licenseFocusNode;

  // Additional focus nodes for Step 3
  late final FocusNode _departmentFocusNode;
  late final FocusNode _degreeFocusNode;
  late final FocusNode _collegeFocusNode;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _primaryFocusNode = FocusNode();
    _secondaryFocusNode = FocusNode();
    _submitButtonFocus = FocusNode();

    _phoneFocusNode = FocusNode();
    _nidFocusNode = FocusNode();
    _licenseFocusNode = FocusNode();

    _departmentFocusNode = FocusNode();
    _degreeFocusNode = FocusNode();
    _collegeFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _announceScreen();
    });
  }

  void _initializeControllers() {
    _loginEmailController = TextEditingController();
    _loginPasswordController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nidController = TextEditingController();
    _licenseController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _specializationController = TextEditingController();
    _hospitalController = TextEditingController();
    _departmentController = TextEditingController();
    _degreeController = TextEditingController();
    _medicalCollegeController = TextEditingController();
  }

  @override
  void dispose() {
    _clearControllers();
    _primaryFocusNode.dispose();
    _secondaryFocusNode.dispose();
    _submitButtonFocus.dispose();
    _phoneFocusNode.dispose();
    _nidFocusNode.dispose();
    _licenseFocusNode.dispose();
    _departmentFocusNode.dispose();
    _degreeFocusNode.dispose();
    _collegeFocusNode.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    _hospitalController.dispose();
    _departmentController.dispose();
    _degreeController.dispose();
    _medicalCollegeController.dispose();
  }

  void _announceScreen() {
    String announcement = '';
    if (_isLogin) {
      announcement = 'Doctor sign-in screen. Enter your email and password.';
    } else {
      announcement =
          'Doctor registration step $_registrationStep of 3. ${_getRegistrationStepTitle()}';
    }
    _announceFeedback(announcement);
  }

  String _getRegistrationStepTitle() {
    switch (_registrationStep) {
      case 1:
        return 'Enter your basic information: name, email, phone, NID, and license number.';
      case 2:
        return 'Create a secure password.';
      case 3:
        return 'Enter your professional credentials: specialization, hospital, department, degree, and medical college.';
      default:
        return '';
    }
  }

  Future<void> _handleDoctorLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    setState(() => _errorMessage = '');

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill all fields');
      _announceFeedback('Error: Please fill all fields');
      return;
    }

    setState(() => _loading = true);
    try {
      await _auth.signInDoctor(email: email, password: password);
      _announceFeedback('Sign-in successful. Redirecting to dashboard...');
      if (mounted) {
        await context.read<AuthCubit>().checkSession();
        if (mounted) {
          context.go('/doctor');
        }
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
      _announceFeedback('Error: ${e.message}');
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Failed to sign in');
      _announceFeedback('Error: Failed to sign in');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleDoctorRegistration() async {
    if (_registrationStep == 1) {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _nidController.text.isEmpty ||
          _licenseController.text.isEmpty) {
        setState(() => _errorMessage = 'Please fill all required fields');
        _announceFeedback('Error: Please fill all required fields');
        return;
      }
      setState(() => _registrationStep = 2);
      _announceScreen();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _primaryFocusNode.requestFocus();
      });
    } else if (_registrationStep == 2) {
      if (_passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        setState(() => _errorMessage = 'Please enter a password');
        _announceFeedback('Error: Please enter a password');
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _errorMessage = 'Passwords do not match');
        _announceFeedback('Error: Passwords do not match');
        return;
      }
      if (_passwordController.text.length < 8) {
        setState(
          () => _errorMessage = 'Password must be at least 8 characters',
        );
        _announceFeedback('Error: Password must be at least 8 characters');
        return;
      }
      setState(() => _registrationStep = 3);
      _announceScreen();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _primaryFocusNode.requestFocus();
      });
    } else if (_registrationStep == 3) {
      if (_specializationController.text.isEmpty ||
          _hospitalController.text.isEmpty ||
          _departmentController.text.isEmpty ||
          _degreeController.text.isEmpty ||
          _medicalCollegeController.text.isEmpty) {
        setState(() => _errorMessage = 'Please fill all professional fields');
        _announceFeedback('Error: Please fill all professional fields');
        return;
      }

      setState(() => _loading = true);
      try {
        final result = await BmdcLicenseVerificationService.verify(
          _licenseController.text.trim(),
        );

        if (!result.isValid) {
          setState(
            () => _errorMessage =
                'License verification failed. Please check your credentials.',
          );
          _announceFeedback(
            'Error: License verification failed. Please check your credentials.',
          );
          return;
        }

        await _auth.signUpDoctor(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          nid: _nidController.text.trim(),
          licenseNumber: _licenseController.text.trim(),
          specialization: _specializationController.text.trim(),
          hospital: _hospitalController.text.trim(),
          department: _departmentController.text.trim(),
          degree: _degreeController.text.trim(),
          medicalCollege: _medicalCollegeController.text.trim(),
        );

        _announceFeedback(
          'Registration successful! Signing in and redirecting to dashboard...',
        );
        if (mounted) {
          await context.read<AuthCubit>().checkSession();
          if (mounted) {
            context.go('/doctor');
          }
        }
      } on AuthException catch (e) {
        if (mounted) setState(() => _errorMessage = e.message);
        _announceFeedback('Error: ${e.message}');
      } catch (e) {
        if (mounted) {
          setState(() => _errorMessage = 'Registration failed. Try again.');
        }
        _announceFeedback('Error: Registration failed. Please try again.');
      } finally {
        if (mounted) setState(() => _loading = false);
      }
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
          onTap: () {
            if (_isLogin) {
              context.pop();
            } else if (_registrationStep > 1) {
              setState(() => _registrationStep--);
              _announceScreen();
            } else {
              setState(() => _isLogin = true);
              _announceScreen();
            }
          },
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 28,
            onPressed: () {
              if (_isLogin) {
                context.pop();
              } else if (_registrationStep > 1) {
                setState(() => _registrationStep--);
                _announceScreen();
              } else {
                setState(() => _isLogin = true);
                _announceScreen();
              }
            },
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
                // Logo
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
                  child: Text(
                    _isLogin ? 'Doctor Sign In' : 'Doctor Registration',
                    style: textTheme.displaySmall,
                  ),
                ),
                const SizedBox(height: 32),

                if (!_isLogin)
                  AppStepIndicator(
                    currentStep: _registrationStep,
                    totalSteps: 3,
                    colorScheme: colorScheme,
                  ),

                if (!_isLogin) const SizedBox(height: 32),

                // Error
                if (_errorMessage.isNotEmpty)
                  AppErrorBanner(
                    message: _errorMessage,
                    colorScheme: colorScheme,
                  ),
                if (_errorMessage.isNotEmpty) const SizedBox(height: 24),

                // Forms
                if (_isLogin)
                  DoctorLoginForm(
                    emailController: _loginEmailController,
                    passwordController: _loginPasswordController,
                    emailFocusNode: _primaryFocusNode,
                    passwordFocusNode: _secondaryFocusNode,
                    submitButtonFocusNode: _submitButtonFocus,
                    loading: _loading,
                    obscurePassword: _obscureLoginPassword,
                    onTogglePassword: () {
                      setState(
                        () => _obscureLoginPassword = !_obscureLoginPassword,
                      );
                      _announceFeedback(
                        _obscureLoginPassword
                            ? 'Password hidden'
                            : 'Password visible',
                      );
                    },
                    onSubmit: _handleDoctorLogin,
                  )
                else if (_registrationStep == 1)
                  DoctorRegistrationStep1Form(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    nidController: _nidController,
                    licenseController: _licenseController,
                    nameFocusNode: _primaryFocusNode,
                    emailFocusNode: _secondaryFocusNode,
                    phoneFocusNode: _phoneFocusNode,
                    nidFocusNode: _nidFocusNode,
                    licenseFocusNode: _licenseFocusNode,
                    submitButtonFocusNode: _submitButtonFocus,
                    loading: _loading,
                    onContinue: _handleDoctorRegistration,
                  )
                else if (_registrationStep == 2)
                  DoctorRegistrationStep2Form(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    passwordFocusNode: _primaryFocusNode,
                    confirmPasswordFocusNode: _secondaryFocusNode,
                    submitButtonFocusNode: _submitButtonFocus,
                    loading: _loading,
                    obscurePassword: _obscurePassword,
                    obscureConfirmPassword: _obscureConfirmPassword,
                    onTogglePassword: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                      _announceFeedback(
                        _obscurePassword
                            ? 'Password hidden'
                            : 'Password visible',
                      );
                    },
                    onToggleConfirmPassword: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                      _announceFeedback(
                        _obscureConfirmPassword
                            ? 'Confirm password hidden'
                            : 'Confirm password visible',
                      );
                    },
                    onContinue: _handleDoctorRegistration,
                  )
                else if (_registrationStep == 3)
                  DoctorRegistrationStep3Form(
                    specializationController: _specializationController,
                    hospitalController: _hospitalController,
                    departmentController: _departmentController,
                    degreeController: _degreeController,
                    collegeController: _medicalCollegeController,
                    specializationFocusNode: _primaryFocusNode,
                    hospitalFocusNode: _secondaryFocusNode,
                    departmentFocusNode: _departmentFocusNode,
                    degreeFocusNode: _degreeFocusNode,
                    collegeFocusNode: _collegeFocusNode,
                    submitButtonFocusNode: _submitButtonFocus,
                    loading: _loading,
                    onSubmit: _handleDoctorRegistration,
                  ),

                const SizedBox(height: 32),

                // Toggle
                _buildToggleAuthMode(colorScheme, textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleAuthMode(ColorScheme colorScheme, TextTheme textTheme) {
    return Semantics(
      label: _isLogin
          ? 'Do not have an account? Tap to register'
          : 'Already have an account? Tap to sign in',
      enabled: true,
      onTap: () {
        setState(() {
          _isLogin = !_isLogin;
          _registrationStep = 1;
        });
        _announceScreen();
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLogin = !_isLogin;
            _registrationStep = 1;
          });
          _announceScreen();
        },
        child: RichText(
          text: TextSpan(
            style: textTheme.bodySmall,
            children: [
              TextSpan(
                text: _isLogin
                    ? 'Don\'t have an account? '
                    : 'Already have an account? ',
              ),
              TextSpan(
                text: _isLogin ? 'Register here' : 'Sign in',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
