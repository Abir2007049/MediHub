import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctor_auth_screen.dart';
import 'doctor_edit_profile_screen.dart';
import 'doctor_history_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  final Map<String, String> doctorData;

  const DoctorHomeScreen({Key? key, required this.doctorData}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  late Map<String, String> _doctorData;

  @override
  void initState() {
    super.initState();
    _doctorData = Map.from(widget.doctorData);
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _doctorData['name'] = prefs.getString('doctor_name') ?? _doctorData['name'] ?? '';
      _doctorData['specialization'] = prefs.getString('doctor_specialization') ?? _doctorData['specialization'] ?? '';
      _doctorData['degree'] = prefs.getString('doctor_degree') ?? _doctorData['degree'] ?? '';
      _doctorData['medicalCollege'] = prefs.getString('doctor_college') ?? _doctorData['medicalCollege'] ?? '';
      _doctorData['license'] = prefs.getString('doctor_license') ?? _doctorData['license'] ?? '';
      _doctorData['hospital'] = prefs.getString('doctor_hospital') ?? _doctorData['hospital'] ?? '';
      _doctorData['department'] = prefs.getString('doctor_department') ?? _doctorData['department'] ?? '';
      _doctorData['location'] = prefs.getString('doctor_location') ?? 'Dhaka';
      _doctorData['description'] = prefs.getString('doctor_description') ?? 'Professional medical expert dedicated to patient care.';
      _doctorData['consultationFee'] = prefs.getString('doctor_consultation_fee') ?? '500';
      _doctorData['diagnostic'] = prefs.getString('doctor_diagnostic') ?? 'MediHub Centre';
      _doctorData['profileImage'] = prefs.getString('doctor_profile_image') ?? '';
    });
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorEditProfileScreen(doctorData: _doctorData),
      ),
    );

    // Reload profile if changes were saved
    if (result == true) {
      await _loadSavedProfile();
    }
  }

  // Clear doctor session
  Future<void> _clearDoctorSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('doctor_email');
    await prefs.remove('doctor_name');
    await prefs.remove('doctor_phone');
    await prefs.remove('doctor_specialization');
    await prefs.remove('doctor_hospital');
    await prefs.remove('doctor_department');
    await prefs.remove('doctor_degree');
    await prefs.remove('doctor_college');
    await prefs.remove('doctor_license');
    await prefs.remove('login_time');
    await prefs.remove('doctor_location');
    await prefs.remove('doctor_description');
    await prefs.remove('doctor_consultation_fee');
    await prefs.remove('doctor_diagnostic');
    await prefs.remove('doctor_profile_image');
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Doctor Dashboard', style: TextStyle(fontSize: 16)),
            Text(
              'Welcome, ${_doctorData['name']}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Patient Consultation History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorHistoryScreen(
                    doctorEmail: _doctorData['email'] ?? '',
                    doctorName: _doctorData['name'] ?? '',
                    doctorSpecialization: _doctorData['specialization'] ?? '',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearDoctorSession().then((_) {
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const DoctorAuthScreen()),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
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
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: _doctorData['profileImage']?.isNotEmpty == true
                            ? ClipOval(
                                child: Image.file(
                                  File(_doctorData['profileImage']!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.medical_services,
                                        color: Colors.green.shade600,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.medical_services,
                                  color: Colors.green.shade600,
                                  size: 40,
                                ),
                              ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _doctorData['name']!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _doctorData['specialization']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'License: ${_doctorData['license']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Information Cards
            Text(
              'Professional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Specialization',
              _doctorData['specialization']!,
              Icons.healing,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Degree',
              _doctorData['degree']!,
              Icons.school,
            ),
            const SizedBox(height: 12),
            if (_doctorData['license']!.isNotEmpty)
              _buildInfoCard(
                'License Number',
                _doctorData['license']!,
                Icons.card_membership,
              ),
            if (_doctorData['license']!.isNotEmpty)
              const SizedBox(height: 12),
            _buildInfoCard(
              'Medical College',
              _doctorData['medicalCollege']!,
              Icons.apartment,
            ),
            if (_doctorData['hospital']!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                'Current Hospital',
                _doctorData['hospital']!,
                Icons.local_hospital,
              ),
            ],
            if (_doctorData['department']!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                'Department',
                _doctorData['department']!,
                Icons.domain,
              ),
            ],
            const SizedBox(height: 24),

            // Contact Information
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Email',
              _doctorData['email']!,
              Icons.email,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Phone',
              _doctorData['phone']!,
              Icons.phone,
            ),
            const SizedBox(height: 24),

            // Additional Information
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Diagnostic Centre',
              _doctorData['diagnostic'] ?? 'MediHub Centre',
              Icons.local_hospital,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Location',
              _doctorData['location'] ?? 'Dhaka',
              Icons.location_on,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Consultation Fee',
              '৳${_doctorData['consultationFee'] ?? '500'}/appointment',
              Icons.attach_money,
            ),
            const SizedBox(height: 24),

            // Professional Bio
            if ((_doctorData['description']?.isNotEmpty ?? false)) ...[
              Text(
                'Professional Bio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Text(
                  _doctorData['description'] ?? 'No bio added',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            const SizedBox(height: 24),

            // Features Section
            Text(
              'Available Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'Manage Schedule',
              'Update your consultation hours and availability',
              Icons.schedule,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'View Appointments',
              'Check upcoming appointments and patient details',
              Icons.event_note,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'Patient Reviews',
              'Monitor ratings and feedback from patients',
              Icons.star,
              Colors.amber,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'Edit Profile',
              'Update your professional information',
              Icons.edit,
              Colors.purple,
              onTap: _navigateToEditProfile,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
