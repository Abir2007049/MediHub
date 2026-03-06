import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/supabase_auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = SupabaseAuthService.instance;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  /// If a Supabase session exists, look up the user's role and navigate.
  Future<void> _checkExistingSession() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final role = await _auth.getUserRole(user.id);

      if (!mounted) return;

      if (role == 'doctor') {
        final profile = await _auth.getDoctorProfile(user.id);
        if (profile != null && mounted) {
          final doctorData = <String, String>{
            'name': profile['full_name']?.toString() ?? '',
            'email': profile['email']?.toString() ?? '',
            'phone': profile['phone']?.toString() ?? '',
            'nid': profile['nid']?.toString() ?? '',
            'license': profile['license']?.toString() ?? '',
            'specialization': profile['specialization']?.toString() ?? '',
            'hospital': profile['hospital']?.toString() ?? '',
            'department': profile['department']?.toString() ?? '',
            'degree': profile['degree']?.toString() ?? '',
            'medicalCollege': profile['medical_college']?.toString() ?? '',
            'location': profile['location']?.toString() ?? 'Dhaka',
            'description': profile['description']?.toString() ?? '',
            'consultationFee': profile['consultation_fee']?.toString() ?? '500',
            'diagnostic': profile['diagnostic']?.toString() ?? 'MediHub Centre',
            'experience': profile['experience']?.toString() ?? '',
            'profileImage': profile['profile_image']?.toString() ?? '',
          };
          context.go('/doctor', extra: doctorData);
        }
      } else if (role == 'patient') {
        final profile = await _auth.getPatientProfile(user.id);
        if (profile != null && mounted) {
          context.go(
            '/patient',
            extra: {
              'patientName': profile['full_name'] as String? ?? '',
              'patientMobile': profile['phone'] as String? ?? '',
            },
          );
        }
      }
    } catch (_) {
      // Session invalid or network error – stay on welcome screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo with gradient
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'MediHub',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Connect with Healthcare Professionals',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Doctor Button
                Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.push('/doctor-auth');
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Continue as Doctor',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Patient Button
                Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade400, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.push('/auth');
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Continue as Patient',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
