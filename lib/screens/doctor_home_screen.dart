import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/doctor_profile/doctor_profile_cubit.dart';
import '../blocs/doctor_profile/doctor_profile_state.dart';
import '../models/doctor_profile.dart';
import '../services/supabase_auth_service.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorProfileCubit>().loadProfile();
  }

  Future<void> _navigateToEditProfile() async {
    final result = await context.push<bool>('/doctor/edit-profile');
    if (result == true) {
      if (mounted) context.read<DoctorProfileCubit>().loadProfile();
    }
  }

  Future<void> _handleLogout() async {
    try {
      await SupabaseAuthService.instance.signOut();
    } catch (_) {}
    if (mounted) context.go('/doctor-auth');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
      builder: (context, state) {
        if (state is DoctorProfileLoading || state is DoctorProfileInitial) {
          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }
        if (state is DoctorProfileError) {
          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: Center(child: Text('Error: ${state.message}')),
          );
        }
        final profile = state is DoctorProfileLoaded
            ? state.profile
            : state is DoctorProfileSaved
            ? state.profile
            : null;
        if (profile == null) {
          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: const Center(child: Text('Profile not found')),
          );
        }
        return _buildScaffold(profile);
      },
    );
  }

  Widget _buildScaffold(DoctorProfile p) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Doctor Dashboard', style: TextStyle(fontSize: 16)),
            Text(
              'Welcome, ${p.fullName}',
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
            onPressed: () => context.push('/doctor/history'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
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
                        child: p.profileImage?.isNotEmpty == true
                            ? ClipOval(
                                child: Image.file(
                                  File(p.profileImage!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.medical_services,
                                      color: Colors.green.shade600,
                                      size: 40,
                                    ),
                                  ),
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
                              p.fullName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.specialization ?? '',
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
                      'License: ${p.license ?? ''}',
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
              p.specialization ?? '',
              Icons.healing,
            ),
            const SizedBox(height: 12),
            _buildInfoCard('Degree', p.degree ?? '', Icons.school),
            const SizedBox(height: 12),
            if ((p.license ?? '').isNotEmpty)
              _buildInfoCard(
                'License Number',
                p.license!,
                Icons.card_membership,
              ),
            if ((p.license ?? '').isNotEmpty) const SizedBox(height: 12),
            _buildInfoCard(
              'Medical College',
              p.medicalCollege ?? '',
              Icons.apartment,
            ),
            if ((p.hospital ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                'Current Hospital',
                p.hospital!,
                Icons.local_hospital,
              ),
            ],
            if ((p.department ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoCard('Department', p.department!, Icons.domain),
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
            _buildInfoCard('Email', p.email, Icons.email),
            const SizedBox(height: 12),
            _buildInfoCard('Phone', p.phone ?? '', Icons.phone),
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
              p.diagnostic,
              Icons.local_hospital,
            ),
            const SizedBox(height: 12),
            _buildInfoCard('Location', p.location, Icons.location_on),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Consultation Fee',
              '৳${p.consultationFee}/appointment',
              Icons.attach_money,
            ),
            const SizedBox(height: 24),

            // Professional Bio
            if ((p.description ?? '').isNotEmpty) ...[
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
                  p.description!,
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
