import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/welcome_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/doctor_auth_screen.dart';
import '../screens/patient_home_screen.dart';
import '../screens/doctor_home_screen.dart';
import '../screens/doctor_profile_screen.dart';
import '../screens/appointment_booking_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/patient_history_screen.dart';
import '../screens/doctor_history_screen.dart';
import '../screens/doctor_edit_profile_screen.dart';
import '../screens/prescription_screen.dart';
import '../screens/patient_prescription_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final path = state.matchedLocation;

    // Public routes that don't require auth
    const publicRoutes = ['/', '/auth', '/doctor-auth'];
    final isPublicRoute = publicRoutes.contains(path);

    // If not logged in and trying to access a protected route → welcome
    if (!isLoggedIn && !isPublicRoute) {
      return '/';
    }

    return null; // no redirect
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
      builder: (context, state) => const DoctorAuthScreen(),
    ),

    // ── Patient flow ──────────────────────────────────────────
    GoRoute(
      path: '/patient',
      name: 'patient-home',
      builder: (context, state) {
        final extra = state.extra as Map<String, String?>? ?? {};
        return PatientHomeScreen(
          patientName: extra['patientName'],
          patientMobile: extra['patientMobile'],
        );
      },
      routes: [
        // Patient appointment history
        GoRoute(
          path: 'history',
          name: 'patient-history',
          builder: (context, state) {
            final patientMobile = state.extra as String;
            return PatientHistoryScreen(patientMobile: patientMobile);
          },
          routes: [
            // View prescription from history
            GoRoute(
              path: 'prescription',
              name: 'patient-prescription',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
                return PatientPrescriptionScreen(
                  prescription: extra['prescription'] as Map<String, dynamic>,
                  appointment: extra['appointment'] as Map<String, dynamic>,
                );
              },
            ),
          ],
        ),

        // Doctor profile (viewed by patient)
        GoRoute(
          path: 'doctor-profile',
          name: 'doctor-profile',
          builder: (context, state) {
            final doctor = state.extra as Map<String, dynamic>;
            return DoctorProfileScreen(doctor: doctor);
          },
          routes: [
            // Appointment booking
            GoRoute(
              path: 'book',
              name: 'appointment-booking',
              builder: (context, state) {
                final doctor = state.extra as Map<String, dynamic>;
                return AppointmentBookingScreen(doctor: doctor);
              },
              routes: [
                // Payment
                GoRoute(
                  path: 'payment',
                  name: 'payment',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    return PaymentScreen(
                      doctor: extra['doctor'] as Map<String, dynamic>,
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

    // ── Doctor flow ───────────────────────────────────────────
    GoRoute(
      path: '/doctor',
      name: 'doctor-home',
      builder: (context, state) {
        final doctorData = state.extra as Map<String, String>;
        return DoctorHomeScreen(doctorData: doctorData);
      },
      routes: [
        // Edit profile
        GoRoute(
          path: 'edit-profile',
          name: 'doctor-edit-profile',
          builder: (context, state) {
            final doctorData = state.extra as Map<String, String>;
            return DoctorEditProfileScreen(doctorData: doctorData);
          },
        ),

        // Doctor consultation history
        GoRoute(
          path: 'history',
          name: 'doctor-history',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>;
            return DoctorHistoryScreen(
              doctorEmail: extra['doctorEmail']!,
              doctorName: extra['doctorName'] ?? '',
              doctorSpecialization: extra['doctorSpecialization'] ?? '',
            );
          },
          routes: [
            // Write / edit prescription
            GoRoute(
              path: 'prescription',
              name: 'prescription',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
                return PrescriptionScreen(
                  appointment: extra['appointment'] as Map<String, dynamic>,
                  doctorEmail: extra['doctorEmail'] as String,
                  doctorName: extra['doctorName'] as String,
                  doctorSpecialization: extra['doctorSpecialization'] as String,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
