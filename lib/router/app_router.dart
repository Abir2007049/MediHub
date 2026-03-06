import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/doctor_profile.dart';
import '../models/appointment.dart';
import '../models/prescription.dart';

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
      builder: (context, state) => const DoctorAuthScreen(),
    ),

    // ── Patient flow ──────────────────────────────────────────
    GoRoute(
      path: '/patient',
      name: 'patient-home',
      builder: (context, state) => const PatientHomeScreen(),
      routes: [
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

    // ── Doctor flow ───────────────────────────────────────────
    GoRoute(
      path: '/doctor',
      name: 'doctor-home',
      builder: (context, state) => const DoctorHomeScreen(),
      routes: [
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
);
