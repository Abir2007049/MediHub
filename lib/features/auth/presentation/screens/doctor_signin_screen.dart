import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import '../widgets/doctor_auth/doctor_login_form.dart';
import 'doctor_signup_screen.dart';

class DoctorSigninScreen extends StatefulWidget {
  const DoctorSigninScreen({super.key});

  @override
  State<DoctorSigninScreen> createState() => _DoctorSigninScreenState();
}

class _DoctorSigninScreenState extends State<DoctorSigninScreen> {
  final _auth = sl<SupabaseAuthService>();

  bool _loading = false;
  bool _isExchanging = false;
  late final TextEditingController _loginEmailController;
  late final TextEditingController _loginPasswordController;
  bool _obscureLoginPassword = true;

  String _errorMessage = '';

  late final FocusNode _primaryFocusNode;
  late final FocusNode _secondaryFocusNode;
  late final FocusNode _submitButtonFocus;

  @override
  void initState() {
    super.initState();
    final uri = GoRouter.of(context).state.uri;
    if (uri.queryParameters['type'] == 'recovery' ||
        uri.queryParameters['type'] == 'signup') {
      _isExchanging = true;
      _exchange(uri);
    }

    if (!_isExchanging) {
      _loginEmailController = TextEditingController();
      _loginPasswordController = TextEditingController();
      _primaryFocusNode = FocusNode();
      _secondaryFocusNode = FocusNode();
      _submitButtonFocus = FocusNode();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _announceScreen();
      });
    }
  }

  @override
  void dispose() {
    if (!_isExchanging) {
      _loginEmailController.dispose();
      _loginPasswordController.dispose();
      _primaryFocusNode.dispose();
      _secondaryFocusNode.dispose();
      _submitButtonFocus.dispose();
    }
    super.dispose();
  }

  Future<void> _exchange(Uri uri) async {
    try {
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
      if (mounted) {
        await context.read<AuthCubit>().checkSession();
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
        context.replace('/doctor/auth');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to authenticate with deep link'),
          ),
        );
        context.replace('/doctor/auth');
      }
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
      log('Sign-in error', error: e);
      if (mounted) setState(() => _errorMessage = 'Failed to sign in');
      _announceFeedback('Error: Failed to sign in');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _announceScreen() {
    _announceFeedback('Doctor sign-in screen. Enter your email and password.');
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
      appBar: _isExchanging
          ? null
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      body: _isExchanging
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Verifying authentication...'),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      image: true,
                      label: 'MediHub logo',
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.medical_services,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Semantics(
                      header: true,
                      child: Text(
                        'Doctor Sign In',
                        style: textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),

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
                      },
                      onSubmit: _handleDoctorLogin,
                    ),

                    const SizedBox(height: 32),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DoctorSignupScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: textTheme.bodySmall,
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Register here',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
