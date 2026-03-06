import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/supabase_auth_service.dart';

class DoctorHomeScreen extends StatefulWidget {
  final Map<String, String> doctorData;

  const DoctorHomeScreen({Key? key, required this.doctorData})
    : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final _auth = SupabaseAuthService.instance;
  late Map<String, String> _doctorData;

  @override
  void initState() {
    super.initState();
    _doctorData = Map.from(widget.doctorData);
    _loadProfileFromSupabase();
  }

  Future<void> _loadProfileFromSupabase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final profile = await _auth.getDoctorProfile(user.id);
      if (profile != null && mounted) {
        setState(() {
          _doctorData['name'] =
              profile['full_name']?.toString() ?? _doctorData['name'] ?? '';
          _doctorData['email'] =
              profile['email']?.toString() ?? _doctorData['email'] ?? '';
          _doctorData['phone'] =
              profile['phone']?.toString() ?? _doctorData['phone'] ?? '';
          _doctorData['specialization'] =
              profile['specialization']?.toString() ??
              _doctorData['specialization'] ??
              '';
          _doctorData['degree'] =
              profile['degree']?.toString() ?? _doctorData['degree'] ?? '';
          _doctorData['medicalCollege'] =
              profile['medical_college']?.toString() ??
              _doctorData['medicalCollege'] ??
              '';
          _doctorData['license'] =
              profile['license']?.toString() ?? _doctorData['license'] ?? '';
          _doctorData['hospital'] =
              profile['hospital']?.toString() ?? _doctorData['hospital'] ?? '';
          _doctorData['department'] =
              profile['department']?.toString() ??
              _doctorData['department'] ??
              '';
          _doctorData['location'] = profile['location']?.toString() ?? 'Dhaka';
          _doctorData['description'] =
              profile['description']?.toString() ??
              'Professional medical expert dedicated to patient care.';
          _doctorData['consultationFee'] =
              profile['consultation_fee']?.toString() ?? '500';
          _doctorData['diagnostic'] =
              profile['diagnostic']?.toString() ?? 'MediHub Centre';
          _doctorData['experience'] = profile['experience']?.toString() ?? '';
          _doctorData['profileImage'] =
              profile['profile_image']?.toString() ?? '';
        });
      }
    } catch (_) {
      // Could not fetch – use data passed via route
    }
  }

  Future<void> _navigateToEditProfile() async {
    final result = await context.push<bool>(
      '/doctor/edit-profile',
      extra: _doctorData,
    );

    // Reload profile if changes were saved
    if (result == true) {
      await _loadProfileFromSupabase();
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
    } catch (_) {}
    if (mounted) {
      context.go('/doctor-auth');
    }
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
              context.push(
                '/doctor/history',
                extra: {
                  'doctorEmail': _doctorData['email'] ?? '',
                  'doctorName': _doctorData['name'] ?? '',
                  'doctorSpecialization': _doctorData['specialization'] ?? '',
                },
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
                        _handleLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'License: ${_doctorData['license']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
            _buildInfoCard('Degree', _doctorData['degree']!, Icons.school),
            const SizedBox(height: 12),
            if (_doctorData['license']!.isNotEmpty)
              _buildInfoCard(
                'License Number',
                _doctorData['license']!,
                Icons.card_membership,
              ),
            if (_doctorData['license']!.isNotEmpty) const SizedBox(height: 12),
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
            _buildInfoCard('Email', _doctorData['email']!, Icons.email),
            const SizedBox(height: 12),
            _buildInfoCard('Phone', _doctorData['phone']!, Icons.phone),
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
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
