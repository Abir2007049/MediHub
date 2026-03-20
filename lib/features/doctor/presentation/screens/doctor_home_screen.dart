import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_profile_cubit.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_profile_state.dart';
import 'package:medihub/features/doctor/presentation/widgets/info_card.dart';
import 'package:medihub/features/doctor/presentation/widgets/feature_card.dart';
import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _primaryContainer => Theme.of(context).colorScheme.primaryContainer;

  @override
  void initState() {
    super.initState();
    // Profile is loaded automatically via DoctorProfileCubit listening to AuthCubit
  }

  Future<void> _navigateToEditProfile() async {
    await context.push<bool>('/doctor/edit-profile');
    // Profile updates are automatically synced through AuthCubit
  }

  Future<void> _handleLogout() async {
    try {
      await sl<SupabaseAuthService>().signOut();
    } catch (_) {}
    if (mounted) context.go('/doctor/auth');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
      builder: (context, state) {
        if (state is DoctorProfileLoading || state is DoctorProfileInitial) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(child: CircularProgressIndicator(color: _primary)),
          );
        }
        if (state is DoctorProfileError) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(child: Text('Profile not found')),
          );
        }
        return _buildScaffold(profile);
      },
    );
  }

  Widget _buildScaffold(DoctorProfile p) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
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
                  colors: [_primary, _secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
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
                                      color: _primary,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.medical_services,
                                  color: _primary,
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
                      color: Colors.white.withAlpha(51),
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
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            InfoCard(
              label: 'Specialization',
              value: p.specialization ?? '',
              icon: Icons.healing,
            ),
            const SizedBox(height: 12),
            InfoCard(
              label: 'Degree',
              value: p.degree ?? '',
              icon: Icons.school,
            ),
            const SizedBox(height: 12),
            if ((p.license ?? '').isNotEmpty)
              InfoCard(
                label: 'License Number',
                value: p.license!,
                icon: Icons.card_membership,
              ),
            if ((p.license ?? '').isNotEmpty) const SizedBox(height: 12),
            InfoCard(
              label: 'Medical College',
              value: p.medicalCollege ?? '',
              icon: Icons.apartment,
            ),
            if ((p.hospital ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              InfoCard(
                label: 'Current Hospital',
                value: p.hospital!,
                icon: Icons.local_hospital,
              ),
            ],
            if ((p.department ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              InfoCard(
                label: 'Department',
                value: p.department!,
                icon: Icons.domain,
              ),
            ],
            const SizedBox(height: 24),

            // Contact Information
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            InfoCard(label: 'Email', value: p.email, icon: Icons.email),
            const SizedBox(height: 12),
            InfoCard(label: 'Phone', value: p.phone ?? '', icon: Icons.phone),
            const SizedBox(height: 24),

            // Additional Information
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            InfoCard(
              label: 'Diagnostic Centre',
              value: p.diagnostic,
              icon: Icons.local_hospital,
            ),
            const SizedBox(height: 12),
            InfoCard(
              label: 'Location',
              value: p.location,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 12),
            InfoCard(
              label: 'Consultation Fee',
              value: '৳${p.consultationFee}/appointment',
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 24),

            // Professional Bio
            if ((p.description ?? '').isNotEmpty) ...[
              Text(
                'Professional Bio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryContainer),
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
            FeatureCard(
              title: 'Manage Schedule',
              description: 'Update your consultation hours and availability',
              icon: Icons.schedule,
              color: _primary,
            ),
            const SizedBox(height: 12),
            FeatureCard(
              title: 'View Appointments',
              description: 'Check upcoming appointments and patient details',
              icon: Icons.event_note,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            FeatureCard(
              title: 'Patient Reviews',
              description: 'Monitor ratings and feedback from patients',
              icon: Icons.star,
              color: Colors.amber,
            ),
            const SizedBox(height: 12),
            FeatureCard(
              title: 'Edit Profile',
              description: 'Update your professional information',
              icon: Icons.edit,
              color: _secondary,
              onTap: _navigateToEditProfile,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
