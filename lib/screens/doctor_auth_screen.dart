import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/services/bmdc_license_verification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../blocs/auth/auth_cubit.dart';
import '../services/supabase_auth_service.dart';

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

  late TextEditingController _loginEmailController;
  late TextEditingController _loginPasswordController;
  bool _obscureLoginPassword = true;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nidController;
  late TextEditingController _licenseController;

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late TextEditingController _specializationController;
  late TextEditingController _hospitalController;
  late TextEditingController _departmentController;
  late TextEditingController _degreeController;
  late TextEditingController _medicalCollegeController;

  String _errorMessage = '';

  late FocusNode _primaryFocusNode;
  late FocusNode _secondaryFocusNode;
  late FocusNode _submitButtonFocus;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _primaryFocusNode = FocusNode();
    _secondaryFocusNode = FocusNode();
    _submitButtonFocus = FocusNode();

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
                  child: Text(
                    _isLogin ? 'Doctor Sign In' : 'Doctor Registration',
                    style: textTheme.displaySmall,
                  ),
                ),
                const SizedBox(height: 32),

                if (!_isLogin)
                  ..._buildProgressIndicator(colorScheme, textTheme),

                if (!_isLogin) const SizedBox(height: 32),

                // Error
                if (_errorMessage.isNotEmpty)
                  ..._buildErrorWidget(_errorMessage, colorScheme),
                if (_errorMessage.isNotEmpty) const SizedBox(height: 24),

                // Forms
                if (_isLogin)
                  ..._buildLoginForm(colorScheme, textTheme)
                else if (_registrationStep == 1)
                  ..._buildRegistrationStep1(colorScheme, textTheme)
                else if (_registrationStep == 2)
                  ..._buildRegistrationStep2(colorScheme, textTheme)
                else if (_registrationStep == 3)
                  ..._buildRegistrationStep3(colorScheme, textTheme),

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

  List<Widget> _buildProgressIndicator(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return [
      Semantics(
        label: 'Registration progress: Step $_registrationStep of 3',
        enabled: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final isActive = i < _registrationStep;
            return Expanded(
              child: Row(
                children: [
                  Semantics(
                    label:
                        'Step ${i + 1}, ${isActive ? "completed" : "pending"}',
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: isActive
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (i < 2)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i < _registrationStep - 1
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    ];
  }

  List<Widget> _buildErrorWidget(String message, ColorScheme colorScheme) {
    return [
      Semantics(
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
      ),
    ];
  }

  List<Widget> _buildLoginForm(ColorScheme colorScheme, TextTheme textTheme) {
    return [
      _buildAccessibleTextField(
        focusNode: _primaryFocusNode,
        controller: _loginEmailController,
        labelText: 'Email Address',
        hintText: 'doctor@example.com',
        prefixIcon: Icons.email,
        keyboardType: TextInputType.emailAddress,
        helperText: 'Enter your registered email address',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 20),
      _buildAccessiblePasswordField(
        focusNode: _secondaryFocusNode,
        controller: _loginPasswordController,
        labelText: 'Password',
        hintText: '••••••••',
        obscure: _obscureLoginPassword,
        onObscureToggle: () {
          setState(() => _obscureLoginPassword = !_obscureLoginPassword);
          _announceFeedback(
            _obscureLoginPassword ? 'Password hidden' : 'Password visible',
          );
        },
        helperText: 'Enter your password',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 32),
      _buildAccessibleButton(
        focusNode: _submitButtonFocus,
        label: 'Sign In',
        onPressed: _loading ? null : _handleDoctorLogin,
        isLoading: _loading,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    ];
  }

  List<Widget> _buildRegistrationStep1(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return [
      _buildAccessibleTextField(
        focusNode: _primaryFocusNode,
        controller: _nameController,
        labelText: 'Full Name',
        hintText: 'Dr. John Doe',
        prefixIcon: Icons.person,
        keyboardType: TextInputType.name,
        helperText: 'Enter your full name as on BMDC certificate',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: _secondaryFocusNode,
        controller: _emailController,
        labelText: 'Email Address',
        hintText: 'doctor@example.com',
        prefixIcon: Icons.email,
        keyboardType: TextInputType.emailAddress,
        helperText: 'Use a professional email address',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: FocusNode(),
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
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: FocusNode(),
        controller: _nidController,
        labelText: 'NID Number',
        hintText: '12345678901234',
        prefixIcon: Icons.badge,
        keyboardType: TextInputType.number,
        maxLength: 17,
        helperText: 'Enter your 13 or 17-digit National ID number',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: FocusNode(),
        controller: _licenseController,
        labelText: 'BMDC License Number',
        hintText: 'A-12345',
        prefixIcon: Icons.card_travel,
        helperText: 'Enter your BMDC license number',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 32),
      _buildAccessibleButton(
        focusNode: _submitButtonFocus,
        label: 'Continue to Password',
        onPressed: _loading ? null : _handleDoctorRegistration,
        isLoading: _loading,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    ];
  }

  List<Widget> _buildRegistrationStep2(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return [
      _buildAccessiblePasswordField(
        focusNode: _primaryFocusNode,
        controller: _passwordController,
        labelText: 'Password',
        hintText: '••••••••',
        obscure: _obscurePassword,
        onObscureToggle: () {
          setState(() => _obscurePassword = !_obscurePassword);
          _announceFeedback(
            _obscurePassword ? 'Password hidden' : 'Password visible',
          );
        },
        helperText:
            'At least 8 characters with uppercase, lowercase, and number',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 20),
      _buildAccessiblePasswordField(
        focusNode: _secondaryFocusNode,
        controller: _confirmPasswordController,
        labelText: 'Confirm Password',
        hintText: '••••••••',
        obscure: _obscureConfirmPassword,
        onObscureToggle: () {
          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
          _announceFeedback(
            _obscureConfirmPassword
                ? 'Confirm password hidden'
                : 'Confirm password visible',
          );
        },
        helperText: 'Passwords must match',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 32),
      _buildAccessibleButton(
        focusNode: _submitButtonFocus,
        label: 'Continue to Credentials',
        onPressed: _loading ? null : _handleDoctorRegistration,
        isLoading: _loading,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    ];
  }

  List<Widget> _buildRegistrationStep3(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return [
      _buildAccessibleTextField(
        focusNode: _primaryFocusNode,
        controller: _specializationController,
        labelText: 'Specialization',
        hintText: 'Cardiology',
        prefixIcon: Icons.medical_services,
        helperText: 'Your primary area of specialization',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: _secondaryFocusNode,
        controller: _hospitalController,
        labelText: 'Hospital/Clinic Name',
        hintText: 'ABC Medical Center',
        prefixIcon: Icons.local_hospital,
        helperText: 'Current or primary hospital/clinic affiliation',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: FocusNode(),
        controller: _departmentController,
        labelText: 'Department',
        hintText: 'Cardiology Department',
        prefixIcon: Icons.category,
        helperText: 'Your department at the hospital/clinic',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: FocusNode(),
        controller: _degreeController,
        labelText: 'Highest Degree',
        hintText: 'MBBS, MD Cardiology',
        prefixIcon: Icons.school,
        helperText: 'Your highest medical degree',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 16),
      _buildAccessibleTextField(
        focusNode: FocusNode(),
        controller: _medicalCollegeController,
        labelText: 'Medical College',
        hintText: 'Medical College',
        prefixIcon: Icons.local_hospital,
        helperText: 'Medical college where you graduated',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      const SizedBox(height: 32),
      _buildAccessibleButton(
        focusNode: _submitButtonFocus,
        label: 'Complete Registration',
        onPressed: _loading ? null : _handleDoctorRegistration,
        isLoading: _loading,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    ];
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
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          _handleDoctorRegistration();
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
              Semantics(
                textField: true,
                enabled: true,
                label: labelText,
                onTap: () => focusNode.requestFocus(),
                child: TextField(
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
    );
  }

  Widget _buildAccessiblePasswordField({
    required FocusNode focusNode,
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool obscure,
    required VoidCallback onObscureToggle,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    String? helperText,
  }) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          _handleDoctorRegistration();
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
              Semantics(
                textField: true,
                enabled: true,
                label: labelText,
                onTap: () => focusNode.requestFocus(),
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  obscureText: obscure,
                  textInputAction: TextInputAction.next,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: labelText,
                    hintText: hintText,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: isFocused
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                    suffixIcon: Semantics(
                      button: true,
                      enabled: true,
                      label: obscure ? 'Show password' : 'Hide password',
                      onTap: onObscureToggle,
                      child: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          color: colorScheme.primary,
                        ),
                        onPressed: onObscureToggle,
                      ),
                    ),
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
                  borderRadius: BorderRadius.circular(8),
                  border: isFocused
                      ? Border.all(color: colorScheme.primary, width: 2)
                      : null,
                  boxShadow: isEnabled
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
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
