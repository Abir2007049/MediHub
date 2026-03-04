import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'patient_home_screen.dart';
import 'auth_screen.dart';
import 'doctor_auth_screen.dart';
import 'doctor_home_screen.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkExistingSessions();
  }

  // Check for existing doctor session
  Future<void> _checkExistingSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final doctorEmail = prefs.getString('doctor_email');
    final patientMobile = prefs.getString('patient_mobile');
    final patientLoginTime = prefs.getString('patient_login_time');
    final loginTime = prefs.getString('login_time');

    // Check patient session first
    if (patientLoginTime != null && patientMobile != null) {
      try {
        final loginDateTime = DateTime.parse(patientLoginTime);
        final now = DateTime.now();
        final diffInHours = now.difference(loginDateTime).inHours;

        // If patient session is still valid (within 8 hours)
        if (diffInHours < 8) {
          final patientName = prefs.getString('patient_name') ?? '';
          
          // Navigate directly to patient home
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientHomeScreen(
                    patientName: patientName,
                    patientMobile: patientMobile,
                  ),
                ),
              );
            }
          });
          return;
        }
      } catch (e) {
        // Invalid timestamp, clear session
        await prefs.remove('patient_login_time');
      }
    }

    // Then check doctor session
    if (loginTime != null) {
      try {
        final loginDateTime = DateTime.parse(loginTime);
        final now = DateTime.now();
        final diffInHours = now.difference(loginDateTime).inHours;

        // If session is still valid (within 8 hours) and doctor is logged in
        if (diffInHours < 8 && doctorEmail != null) {
          // Get saved doctor data
          final doctorData = {
            'email': doctorEmail,
            'name': prefs.getString('doctor_name') ?? '',
            'phone': prefs.getString('doctor_phone') ?? '',
            'specialization': prefs.getString('doctor_specialization') ?? '',
            'hospital': prefs.getString('doctor_hospital') ?? '',
            'department': prefs.getString('doctor_department') ?? '',
            'degree': prefs.getString('doctor_degree') ?? '',
            'medicalCollege': prefs.getString('doctor_college') ?? '',
            'license': prefs.getString('doctor_license') ?? '',
            'profileImage': prefs.getString('doctor_profile_image') ?? '',
          };

          // Navigate directly to doctor home
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorHomeScreen(doctorData: doctorData),
                ),
              );
            }
          });
          return;
        }
      } catch (e) {
        // Invalid timestamp, clear session
        await prefs.remove('login_time');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.current;
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DoctorAuthScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services, color: Colors.white, size: 24),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, color: Colors.green.shade600, size: 24),
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
