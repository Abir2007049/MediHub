import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import '../blocs/auth/auth_cubit.dart';
import '../services/supabase_auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = SupabaseAuthService.instance;
  late FocusNode _doctorButtonFocus;
  late FocusNode _patientButtonFocus;

  @override
  void initState() {
    super.initState();
    _doctorButtonFocus = FocusNode();
    _patientButtonFocus = FocusNode();
    _checkExistingSession();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SemanticsService.announce(
        'Welcome to MediHub. Choose to continue as a doctor or patient.',
        TextDirection.ltr,
      );
    });
  }

  @override
  void dispose() {
    _doctorButtonFocus.dispose();
    _patientButtonFocus.dispose();
    super.dispose();
  }

  Future<void> _checkExistingSession() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final role = await _auth.getUserRole(user.id);
      if (!mounted) return;

      await context.read<AuthCubit>().checkSession();
      if (!mounted) return;

      if (role == 'doctor') {
        context.go('/doctor');
      } else if (role == 'patient') {
        context.go('/patient');
      }
    } catch (_) {
      // Stay on welcome screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Logo Container
                Semantics(
                  image: true,
                  label: 'MediHub logo',
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_hospital,
                      size: 64,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 54),

                // Title
                Semantics(
                  header: true,
                  child: Text(
                    'MediHub',
                    style: textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Semantics(
                  label: 'Connect with healthcare professionals',
                  enabled: true,
                  child: Text(
                    'Connect with Healthcare Professionals',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Tagline
                Semantics(
                  label: 'Get quality healthcare at your convenience',
                  child: Text(
                    'Get quality healthcare at your convenience',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 72),

                // Doctor Button
                Semantics(
                  button: true,
                  enabled: true,
                  onTap: () => context.push('/doctor-auth'),
                  label: 'Continue as Doctor',
                  tooltip: 'Sign in or register as a healthcare professional',
                  child: Focus(
                    focusNode: _doctorButtonFocus,
                    onKey: (node, event) {
                      if (event.logicalKey == LogicalKeyboardKey.enter ||
                          event.logicalKey == LogicalKeyboardKey.space) {
                        context.push('/doctor-auth');
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: GestureDetector(
                      onTap: () => context.push('/doctor-auth'),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Builder(
                          builder: (context) {
                            final isFocused = Focus.of(context).hasFocus;
                            return Container(
                              width: double.infinity,
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.secondary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: isFocused
                                    ? Border.all(
                                        color: colorScheme.primary,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.badge,
                                    color: colorScheme.onPrimary,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Continue as Doctor',
                                    style: textTheme.labelLarge?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Patient Button
                Semantics(
                  button: true,
                  enabled: true,
                  onTap: () => context.push('/auth'),
                  label: 'Continue as Patient',
                  tooltip: 'Book appointments with doctors',
                  child: Focus(
                    focusNode: _patientButtonFocus,
                    onKey: (node, event) {
                      if (event.logicalKey == LogicalKeyboardKey.enter ||
                          event.logicalKey == LogicalKeyboardKey.space) {
                        context.push('/auth');
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: GestureDetector(
                      onTap: () => context.push('/auth'),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Builder(
                          builder: (context) {
                            final isFocused = Focus.of(context).hasFocus;
                            return Container(
                              width: double.infinity,
                              height: 64,
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isFocused
                                      ? colorScheme.primary
                                      : colorScheme.primary.withOpacity(0.5),
                                  width: isFocused ? 3 : 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: colorScheme.primary,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Continue as Patient',
                                    style: textTheme.labelLarge?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
