import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medihub/core/theme/app_theme.dart';

import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/models/prescription.dart';

import 'package:medihub/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:medihub/features/auth/presentation/screens/auth_screen.dart';
import 'package:medihub/features/auth/presentation/screens/doctor_signin_screen.dart';
import 'package:medihub/features/auth/presentation/screens/doctor_signup_screen.dart';
import 'package:medihub/features/patient/presentation/screens/patient_home_screen.dart';
import 'package:medihub/features/doctor/presentation/screens/doctor_home_screen.dart';
import 'package:medihub/features/doctor/presentation/screens/doctor_profile_screen.dart';
import 'package:medihub/features/appointments/presentation/screens/appointment_booking_screen.dart';
import 'package:medihub/features/appointments/presentation/screens/payment_screen.dart';
import 'package:medihub/features/patient/presentation/screens/patient_history_screen.dart';
import 'package:medihub/features/doctor/presentation/screens/doctor_history_screen.dart';
import 'package:medihub/features/doctor/presentation/screens/doctor_edit_profile_screen.dart';
import 'package:medihub/features/prescription/presentation/screens/prescription_screen.dart';
import 'package:medihub/features/prescription/presentation/screens/patient_prescription_screen.dart';

class GoRouterRefreshStream<T> extends ChangeNotifier {
  GoRouterRefreshStream(Stream<T> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final path = state.matchedLocation;

    const publicRoutes = [
      '/',
      '/patient/auth',
      '/doctor/auth',
      '/doctor/auth/signup',
      '/login-callback',
    ];
    final isPublicRoute = publicRoutes.contains(path);

    if (!isLoggedIn && !isPublicRoute) {
      return '/';
    }

    return null;
  },
  routes: [
    // ── Auth / Welcome ────────────────────────────────────────
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    // ── Patient flow ──────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) =>
          Theme(data: getPatientTheme(), child: child),
      routes: [
        GoRoute(
          path: '/patient',
          name: 'patient-home',
          builder: (context, state) => const PatientHomeScreen(),
          routes: [
            GoRoute(
              path: '/auth',
              name: 'auth',
              builder: (context, state) => const AuthScreen(),
            ),
            GoRoute(
              path: 'history',
              name: 'patient-history',
              builder: (context, state) => const PatientHistoryScreen(),
              routes: [
                GoRoute(
                  path: 'prescription',
                  name: 'patient-prescription',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    return PatientPrescriptionScreen(
                      prescription: extra['prescription'] as Prescription,
                      appointment: extra['appointment'] as Appointment,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'doctor-profile',
              name: 'doctor-profile',
              builder: (context, state) {
                final doctor = state.extra as DoctorProfile;
                return DoctorProfileScreen(doctor: doctor);
              },
              routes: [
                GoRoute(
                  path: 'book',
                  name: 'appointment-booking',
                  builder: (context, state) {
                    final doctor = state.extra as DoctorProfile;
                    return AppointmentBookingScreen(doctor: doctor);
                  },
                  routes: [
                    GoRoute(
                      path: 'payment',
                      name: 'payment',
                      builder: (context, state) {
                        final extra = state.extra as Map<String, dynamic>;
                        return PaymentScreen(
                          doctor: extra['doctor'] as DoctorProfile,
                          selectedDay: extra['selectedDay'] as String,
                          selectedSerialNumber:
                              extra['selectedSerialNumber'] as int,
                          approximateTime: extra['approximateTime'] as String?,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ── Doctor flow ───────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) =>
          Theme(data: getDoctorTheme(), child: child),
      routes: [
        GoRoute(
          path: '/doctor',
          name: 'doctor-home',
          builder: (context, state) => const DoctorHomeScreen(),
          routes: [
            GoRoute(
              path: '/auth',
              name: 'doctor-signin',
              builder: (context, state) => const DoctorSigninScreen(),
              routes: [
                GoRoute(
                  path: '/signup',
                  name: 'doctor-signup',
                  builder: (context, state) => const DoctorSignupScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'edit-profile',
              name: 'doctor-edit-profile',
              builder: (context, state) => const DoctorEditProfileScreen(),
            ),
            GoRoute(
              path: 'history',
              name: 'doctor-history',
              builder: (context, state) => const DoctorHistoryScreen(),
              routes: [
                GoRoute(
                  path: 'prescription',
                  name: 'prescription',
                  builder: (context, state) {
                    final appointment = state.extra as Appointment;
                    return PrescriptionScreen(appointment: appointment);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
