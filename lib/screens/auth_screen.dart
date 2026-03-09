import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../blocs/auth/auth_cubit.dart';
import '../models/patient_profile.dart';
import '../services/supabase_auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = SupabaseAuthService.instance;

  // Steps: 0 = phone input, 1 = OTP verification, 2 = name (new user)
  int _step = 0;
  bool _loading = false;

  late TextEditingController _phoneController;
  late TextEditingController _otpController;
  late TextEditingController _nameController;

  String _formattedPhone = '';

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// Convert local BD number (01XXXXXXXXX) to E.164 (+880XXXXXXXXX).
  String _toE164(String local) {
    final digits = local.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      return '+88$digits';
    }
    if (digits.startsWith('880')) {
      return '+$digits';
    }
    return '+880$digits';
  }

  // ─── Step 0: Request OTP ───────────────────────────────────

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      _showSnackBar('Please enter your mobile number', Colors.red);
      return;
    }

    if (phone.length != 11 || !phone.startsWith('01')) {
      _showSnackBar(
        'Mobile number must be 11 digits starting with 01',
        Colors.red,
      );
      return;
    }

    _formattedPhone = _toE164(phone);

    setState(() => _loading = true);
    try {
      await _auth.sendOtp(phone: _formattedPhone);
      setState(() => _step = 1);
      _showSnackBar('OTP sent to $phone', Colors.green);
    } on AuthException catch (e) {
      _showSnackBar(e.message, Colors.red);
    } catch (e) {
      _showSnackBar('Failed to send OTP. Please try again.', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  // ─── Step 1: Verify OTP ────────────────────────────────────

  Future<void> _verifyOtp() async {
    final token = _otpController.text.trim();

    if (token.isEmpty || token.length != 6) {
      _showSnackBar('Please enter the 6-digit code', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await _auth.verifyOtp(
        phone: _formattedPhone,
        token: token,
      );

      final user = response.user;
      if (user == null) {
        _showSnackBar('Verification failed', Colors.red);
        return;
      }

      // Check if profile already exists
      final profile = await _auth.getPatientProfile(user.id);

      if (profile != null && profile['full_name'] != null) {
        // Existing user → go to patient home
        _showSnackBar('Welcome back, ${profile['full_name']}!', Colors.green);
        if (mounted) {
          context.read<AuthCubit>().setPatientAuthenticated(
            PatientProfile.fromJson(profile),
          );
          context.go('/patient');
        }
      } else {
        // New user → ask for name
        setState(() => _step = 2);
      }
    } on AuthException catch (e) {
      _showSnackBar(e.message, Colors.red);
    } catch (e) {
      _showSnackBar('Verification failed. Please try again.', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  // ─── Step 2: Save name for new user ────────────────────────

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();

    if (name.isEmpty || name.length < 2) {
      _showSnackBar('Please enter your full name', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      final user = _auth.currentUser!;
      await _auth.upsertPatientProfile(
        userId: user.id,
        fullName: name,
        phone: _phoneController.text.trim(),
      );

      _showSnackBar('Welcome, $name!', Colors.green);
      if (mounted) {
        final freshProfile = await _auth.getPatientProfile(user.id);
        if (freshProfile != null) {
          context.read<AuthCubit>().setPatientAuthenticated(
            PatientProfile.fromJson(freshProfile),
          );
        }
        context.go('/patient');
      }
    } catch (e) {
      _showSnackBar('Failed to save profile. Please try again.', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Logo ──
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'MediHub',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Book Your Appointment',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // ── Step indicator ──
                _buildStepIndicator(),
                const SizedBox(height: 32),

                // ── Form per step ──
                if (_step == 0) _buildPhoneStep(),
                if (_step == 1) _buildOtpStep(),
                if (_step == 2) _buildNameStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Step Indicator ────────────────────────────────────────

  Widget _buildStepIndicator() {
    final labels = ['Phone', 'Verify', 'Profile'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i <= _step;
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.green : Colors.grey.shade300,
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (i < 2) ...[
              const SizedBox(width: 4),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? Colors.green : Colors.grey,
                ),
              ),
              Container(
                width: 30,
                height: 2,
                color: i < _step ? Colors.green : Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ] else ...[
              const SizedBox(width: 4),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  // ─── Step 0: Phone ─────────────────────────────────────────

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'e.g., 01712345678',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.phone, color: Colors.green.shade600),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade500, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: 'Send OTP',
          icon: Icons.sms,
          onPressed: _loading ? null : _sendOtp,
        ),
        const SizedBox(height: 16),
        _buildInfoBox(
          'We will send a 6-digit verification code to your mobile number via SMS.',
        ),
      ],
    );
  }

  // ─── Step 1: OTP ───────────────────────────────────────────

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Enter the code sent to ${_phoneController.text}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '6-Digit Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            letterSpacing: 12,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: '000000',
            hintStyle: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 28,
              letterSpacing: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade500, width: 2),
            ),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: 'Verify',
          icon: Icons.check_circle,
          onPressed: _loading ? null : _verifyOtp,
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: _loading
                ? null
                : () async {
                    setState(() => _loading = true);
                    try {
                      await _auth.sendOtp(phone: _formattedPhone);
                      _showSnackBar('OTP resent!', Colors.green);
                    } catch (e) {
                      _showSnackBar('Failed to resend OTP', Colors.red);
                    }
                    setState(() => _loading = false);
                  },
            child: Text(
              'Resend Code',
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _step = 0;
                _otpController.clear();
              });
            },
            child: Text(
              'Change Number',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Step 2: Name ──────────────────────────────────────────

  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Icon(Icons.person_add, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              Text(
                'Almost there! Tell us your name.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Full Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.person, color: Colors.green.shade600),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade500, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: 'Continue',
          icon: Icons.arrow_forward,
          onPressed: _loading ? null : _saveProfile,
        ),
      ],
    );
  }

  // ─── Shared widgets ────────────────────────────────────────

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade500,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 56),
        elevation: 4,
      ),
      child: _loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
