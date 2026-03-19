import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';

class PatientDrawer extends StatelessWidget {
  final String? patientName;

  const PatientDrawer({super.key, this.patientName});

  Future<void> _clearPatientSession(BuildContext context) async {
    await sl<SupabaseAuthService>().signOut();
    if (context.mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primary.withOpacity(0.05)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: primary, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  patientName ?? 'Patient',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: primary),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.history, color: primary),
            title: const Text('Appointment History'),
            onTap: () {
              Navigator.pop(context);
              context.push('/patient/history');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline, color: primary),
            title: const Text('Profile'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: primary),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _clearPatientSession(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
    );
  }
}
