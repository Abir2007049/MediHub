import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../blocs/auth/auth_cubit.dart';
import '../services/bmdc_license_verification_service.dart';
import '../services/supabase_auth_service.dart';

class DoctorAuthScreen extends StatefulWidget {
  const DoctorAuthScreen({super.key});

  @override
  State<DoctorAuthScreen> createState() => _DoctorAuthScreenState();
}

class _DoctorAuthScreenState extends State<DoctorAuthScreen> {
  final _auth = SupabaseAuthService.instance;

  bool _isLogin = true;
  int _registrationStep = 1;
  bool _loading = false;

  // Login controllers
  late TextEditingController _loginEmailController;
  late TextEditingController _loginPasswordController;

  // Registration Step 1 controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nidController;
  late TextEditingController _licenseController;

  // Registration Step 2 controllers
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _specializationController;
  late TextEditingController _hospitalController;
  late TextEditingController _departmentController;
  late TextEditingController _degreeController;
  late TextEditingController _medicalCollegeController;

  bool _obscureLoginPassword = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loginEmailController = TextEditingController();
    _loginPasswordController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nidController = TextEditingController();
    _licenseController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _specializationController = TextEditingController();
    _hospitalController = TextEditingController();
    _departmentController = TextEditingController();
    _degreeController = TextEditingController();
    _medicalCollegeController = TextEditingController();
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    _hospitalController.dispose();
    _departmentController.dispose();
    _degreeController.dispose();
    _medicalCollegeController.dispose();
    super.dispose();
  }

  // ─── Login ─────────────────────────────────────────────────

  Future<void> _handleDoctorLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await _auth.signInDoctor(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        _showSnackBar('Login failed', Colors.red);
        return;
      }

      // Fetch doctor profile from DB
      final profile = await _auth.getDoctorProfile(user.id);

      if (profile == null) {
        _showSnackBar('Doctor profile not found', Colors.red);
        return;
      }

      _showSnackBar('Welcome ${profile['full_name']}!', Colors.green);
      if (mounted) {
        await context.read<AuthCubit>().checkSession();
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go('/doctor');
        }
      });
    } on AuthException catch (e) {
      _showSnackBar(e.message, Colors.red);
    } catch (e) {
      _showSnackBar('Login failed. Please try again.', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  // ─── Registration Step 1 ───────────────────────────────────

  Future<void> _handleRegistrationStep1() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final nid = _nidController.text.trim();
    final license = _licenseController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        nid.isEmpty ||
        license.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    if (nid.length != 13 || !nid.contains(RegExp(r'^[0-9]+$'))) {
      _showSnackBar('NID must be 13 digits', Colors.red);
      return;
    }

    if (!email.contains('@')) {
      _showSnackBar('Please enter a valid email', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      final bmdcResult = await BmdcLicenseVerificationService.verify(license);
      if (!bmdcResult.isValid) {
        _showSnackBar(bmdcResult.message, Colors.red);
        return;
      }

      _licenseController.text = bmdcResult.normalizedLicense;

      setState(() {
        _registrationStep = 2;
      });
      _showSnackBar('BMDC license verified. Proceed to step 2', Colors.green);
    } catch (e) {
      _showSnackBar('License verification failed: $e', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  // ─── Registration Step 2 ───────────────────────────────────

  Future<void> _handleRegistrationStep2() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final specialization = _specializationController.text.trim();
    final degree = _degreeController.text.trim();
    final medicalCollege = _medicalCollegeController.text.trim();

    if (password.isEmpty ||
        confirmPassword.isEmpty ||
        specialization.isEmpty ||
        degree.isEmpty ||
        medicalCollege.isEmpty) {
      _showSnackBar('Please fill all required fields', Colors.red);
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters', Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      // 1. Create auth user
      final response = await _auth.signUpDoctor(
        email: _emailController.text.trim(),
        password: password,
      );

      final user = response.user;
      if (user == null) {
        _showSnackBar('Registration failed', Colors.red);
        return;
      }

      // 2. Create doctor profile row in DB
      await _auth.createDoctorProfile(
        userId: user.id,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        nid: _nidController.text.trim(),
        license: _licenseController.text.trim(),
        specialization: specialization,
        hospital: _hospitalController.text.trim(),
        department: _departmentController.text.trim(),
        degree: degree,
        medicalCollege: medicalCollege,
      );

      _showSnackBar(
        'Account created! Check your email to confirm, then login.',
        Colors.green,
      );

      // Sign out so they can confirm email and login fresh
      await _auth.signOut();

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLogin = true;
            _registrationStep = 1;
            _clearControllers();
          });
        }
      });
    } on AuthException catch (e) {
      _showSnackBar(e.message, Colors.red);
    } on PostgrestException catch (e) {
      _showSnackBar(e.message, Colors.red);
    } catch (e) {
      _showSnackBar('Registration failed. Please try again.', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  // ─── Helpers ───────────────────────────────────────────────

  void _clearControllers() {
    _loginEmailController.clear();
    _loginPasswordController.clear();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _nidController.clear();
    _licenseController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _specializationController.clear();
    _hospitalController.clear();
    _departmentController.clear();
    _degreeController.clear();
    _medicalCollegeController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'MediHub Doctors',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage Your Practice',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Tab Switcher
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = true;
                              _registrationStep = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isLogin
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _isLogin
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isLogin
                                      ? Colors.green
                                      : Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = false;
                              _registrationStep = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isLogin
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: !_isLogin
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !_isLogin
                                      ? Colors.green
                                      : Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Login Form
                if (_isLogin) ...[
                  Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _loginEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                      prefixIconColor: Colors.green,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _loginPasswordController,
                    obscureText: _obscureLoginPassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor: Colors.green,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscureLoginPassword = !_obscureLoginPassword,
                        ),
                        child: Icon(
                          _obscureLoginPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.green,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loading ? null : _handleDoctorLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ] else ...[
                  // Registration Form
                  if (_registrationStep == 1) ...[
                    // Step 1: Basic Info
                    const Text(
                      'Step 1: Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Full Name', _nameController, Icons.person),
                    const SizedBox(height: 12),
                    _buildTextField('Email', _emailController, Icons.email),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Phone Number',
                      _phoneController,
                      Icons.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'NID Number (13 digits)',
                      _nidController,
                      Icons.badge,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'BMDC License (e.g., A-12345)',
                      _licenseController,
                      Icons.card_membership,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleRegistrationStep1,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 56),
                        elevation: 4,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Step 2: Credentials & Professional Info
                    const Text(
                      'Step 2: Professional Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Password',
                      _passwordController,
                      Icons.lock,
                      obscure: _obscurePassword,
                      onToggleObscure: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Confirm Password',
                      _confirmPasswordController,
                      Icons.lock,
                      obscure: _obscureConfirmPassword,
                      onToggleObscure: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Specialization',
                      _specializationController,
                      Icons.healing,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Degree (e.g., MBBS, MD)',
                      _degreeController,
                      Icons.school,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Medical College',
                      _medicalCollegeController,
                      Icons.apartment,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Current Hospital (Optional)',
                      _hospitalController,
                      Icons.local_hospital,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Department (Optional)',
                      _departmentController,
                      Icons.domain,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _registrationStep = 1;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _loading
                                ? null
                                : _handleRegistrationStep2,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            prefixIcon: Icon(icon),
            prefixIconColor: Colors.green,
            suffixIcon: onToggleObscure != null
                ? GestureDetector(
                    onTap: onToggleObscure,
                    child: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.green,
                    ),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }
}
