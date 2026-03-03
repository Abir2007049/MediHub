import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'patient_home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  late TextEditingController _mobileController;
  late TextEditingController _nameController;
  late TextEditingController _pinController;
  bool _obscurePin = true;

  // Demo registered users - in real app, this comes from backend
  final List<Map<String, String>> _registeredUsers = [
    {
      'mobile': '01712345678',
      'name': 'Ahmed Khan',
      'pin': '12345',
    },
    {
      'mobile': '01898765432',
      'name': 'Fatima Begum',
      'pin': '54321',
    },
  ];

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _nameController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _nameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  bool _isValidMobile(String mobile) {
    return mobile.length == 11 && mobile.startsWith('01');
  }

  bool _isValidPin(String pin) {
    return pin.length == 5 && int.tryParse(pin) != null;
  }

  Future<void> _savePatientSession(String mobile, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('patient_mobile', mobile);
    await prefs.setString('patient_name', name);
    await prefs.setString('patient_login_time', DateTime.now().toIso8601String());
  }

  void _handleLogin() async {
    final mobile = _mobileController.text.trim();
    final pin = _pinController.text.trim();

    if (mobile.isEmpty || pin.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    if (!_isValidMobile(mobile)) {
      _showSnackBar('Mobile number must be 11 digits starting with 01', Colors.red);
      return;
    }

    if (!_isValidPin(pin)) {
      _showSnackBar('PIN must be 5 digits', Colors.red);
      return;
    }

    // Check credentials
    final user = _registeredUsers.firstWhere(
      (user) => user['mobile'] == mobile && user['pin'] == pin,
      orElse: () => {},
    );

    if (user.isEmpty) {
      _showSnackBar('Invalid mobile number or PIN', Colors.red);
      return;
    }

    // Save session
    await _savePatientSession(mobile, user['name']!);

    // Login successful
    _showSnackBar('Welcome ${user['name']}!', Colors.green);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PatientHomeScreen(
              patientName: user['name']!,
              patientMobile: mobile,
            ),
          ),
        );
      }
    });
  }

  void _handleSignUp() async {
    final mobile = _mobileController.text.trim();
    final name = _nameController.text.trim();
    final pin = _pinController.text.trim();

    if (mobile.isEmpty || name.isEmpty || pin.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    if (!_isValidMobile(mobile)) {
      _showSnackBar('Mobile number must be 11 digits starting with 01', Colors.red);
      return;
    }

    if (name.length < 2) {
      _showSnackBar('Full name must be at least 2 characters', Colors.red);
      return;
    }

    if (!_isValidPin(pin)) {
      _showSnackBar('PIN must be 5 digits', Colors.red);
      return;
    }

    // Check if user already exists
    final userExists = _registeredUsers.any((user) => user['mobile'] == mobile);
    if (userExists) {
      _showSnackBar('Mobile number already registered', Colors.red);
      return;
    }

    // Register new user
    _registeredUsers.add({
      'mobile': mobile,
      'name': name,
      'pin': pin,
    });

    // Save session and auto-login
    await _savePatientSession(mobile, name);

    _showSnackBar('Account created! Welcome ${name}!', Colors.green);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PatientHomeScreen(
              patientName: name,
              patientMobile: mobile,
            ),
          ),
        );
      }
    });
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with icon and branding
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

                // Tab Switcher
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.green.shade100, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isLogin = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: _isLogin
                                  ? LinearGradient(
                                      colors: [Colors.green.shade400, Colors.green.shade600],
                                    )
                                  : null,
                              color: _isLogin ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _isLogin
                                  ? [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isLogin ? Colors.white : Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isLogin = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: !_isLogin
                                  ? LinearGradient(
                                      colors: [Colors.green.shade400, Colors.green.shade600],
                                    )
                                  : null,
                              color: !_isLogin ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: !_isLogin
                                  ? [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !_isLogin ? Colors.white : Colors.grey.shade600,
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
                const SizedBox(height: 32),

                // Form Fields  
                if (!_isLogin) ...[
                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(_nameController, 'Enter your full name', Icons.person),
                  const SizedBox(height: 16),
                ],

                Text(
                  'Mobile Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTextField(_mobileController, 'e.g., 01712345678', Icons.phone, isPhone: true),
                const SizedBox(height: 16),

                Text(
                  '5-Digit PIN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                _buildPinField(),
                const SizedBox(height: 28),

                // Submit Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isLogin ? _handleLogin : _handleSignUp,
                      borderRadius: BorderRadius.circular(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isLogin ? Icons.login : Icons.app_registration,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isLogin ? 'Login' : 'Create Account',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Demo Credentials Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Demo Credentials',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mobile: 01712345678 | PIN: 12345',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Signup with any name to create an account',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPhone = false}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.green.shade600),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPinField() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _pinController,
        obscureText: _obscurePin,
        keyboardType: TextInputType.number,
        maxLength: 5,
        decoration: InputDecoration(
          hintText: 'Enter 5-digit PIN',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.lock, color: Colors.green.shade600),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePin = !_obscurePin),
            child: Icon(
              _obscurePin ? Icons.visibility_off : Icons.visibility,
              color: Colors.green.shade600,
            ),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          counterText: '',
        ),
      ),
    );
  }
