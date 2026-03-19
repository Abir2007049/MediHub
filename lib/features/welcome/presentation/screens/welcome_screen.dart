import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/semantics.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = sl<SupabaseAuthService>();
  late FocusNode _doctorButtonFocus;
  late FocusNode _patientButtonFocus;

  @override
  void initState() {
    super.initState();
    _doctorButtonFocus = FocusNode();
    _patientButtonFocus = FocusNode();
    _checkExistingSession();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SemanticsService.sendAnnouncement(
        View.of(context),
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
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
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
                  onTap: () => context.push('/doctor/auth'),
                  label: 'Continue as Doctor',
                  tooltip: 'Sign in or register as a healthcare professional',
                  child: FilledButton.icon(
                    onPressed: () => context.push('/doctor/auth'),
                    label: const Text('Continue as Doctor'),
                    icon: const Icon(Icons.badge),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: textTheme.labelLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      iconSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Patient Button
                Semantics(
                  button: true,
                  enabled: true,
                  onTap: () => context.push('/patient/auth'),
                  label: 'Continue as Patient',
                  tooltip: 'Book appointments with doctors',
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/patient/auth'),
                    label: const Text('Continue as Patient'),
                    icon: const Icon(Icons.person),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: textTheme.labelLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(color: colorScheme.primary, width: 2),
                      iconSize: 28,
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
