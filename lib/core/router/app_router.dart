import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medihub/core/theme/app_theme.dart';

import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/models/prescription.dart';

import 'package:medihub/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:medihub/features/auth/presentation/screens/auth_screen.dart';
import 'package:medihub/features/auth/presentation/screens/doctor_auth_screen.dart';
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

Widget _withPatientTheme(Widget child) {
  return Theme(data: getPatientTheme(), child: child);
}

Widget _withDoctorTheme(Widget child) {
  return Theme(data: getDoctorTheme(), child: child);
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final path = state.matchedLocation;

    const publicRoutes = ['/', '/auth', '/doctor-auth'];
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
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/doctor-auth',
      name: 'doctor-auth',
      builder: (context, state) => _withDoctorTheme(const DoctorAuthScreen()),
    ),

    // ── Patient flow ──────────────────────────────────────────
    GoRoute(
      path: '/patient',
      name: 'patient-home',
      builder: (context, state) => _withPatientTheme(const PatientHomeScreen()),
      routes: [
        GoRoute(
          path: 'history',
          name: 'patient-history',
          builder: (context, state) =>
              _withPatientTheme(const PatientHistoryScreen()),
          routes: [
            GoRoute(
              path: 'prescription',
              name: 'patient-prescription',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
                return _withPatientTheme(
                  PatientPrescriptionScreen(
                    prescription: extra['prescription'] as Prescription,
                    appointment: extra['appointment'] as Appointment,
                  ),
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
            return _withPatientTheme(DoctorProfileScreen(doctor: doctor));
          },
          routes: [
            GoRoute(
              path: 'book',
              name: 'appointment-booking',
              builder: (context, state) {
                final doctor = state.extra as DoctorProfile;
                return _withPatientTheme(
                  AppointmentBookingScreen(doctor: doctor),
                );
              },
              routes: [
                GoRoute(
                  path: 'payment',
                  name: 'payment',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    return _withPatientTheme(
                      PaymentScreen(
                        doctor: extra['doctor'] as DoctorProfile,
                        selectedDay: extra['selectedDay'] as String,
                        selectedSerialNumber:
                            extra['selectedSerialNumber'] as int,
                        approximateTime: extra['approximateTime'] as String?,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ── Doctor flow ───────────────────────────────────────────
    GoRoute(
      path: '/doctor',
      name: 'doctor-home',
      builder: (context, state) => _withDoctorTheme(const DoctorHomeScreen()),
      routes: [
        GoRoute(
          path: 'edit-profile',
          name: 'doctor-edit-profile',
          builder: (context, state) =>
              _withDoctorTheme(const DoctorEditProfileScreen()),
        ),
        GoRoute(
          path: 'history',
          name: 'doctor-history',
          builder: (context, state) =>
              _withDoctorTheme(const DoctorHistoryScreen()),
          routes: [
            GoRoute(
              path: 'prescription',
              name: 'prescription',
              builder: (context, state) {
                final appointment = state.extra as Appointment;
                return _withDoctorTheme(
                  PrescriptionScreen(appointment: appointment),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
