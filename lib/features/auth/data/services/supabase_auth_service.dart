import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized Supabase auth + profile helper for MediHub.
class SupabaseAuthService {
  SupabaseAuthService();

  final _client = Supabase.instance.client;

  // ──────────────────────────────────────────────────────────
  // Getters
  // ──────────────────────────────────────────────────────────

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isLoggedIn => currentUser != null;

  // ──────────────────────────────────────────────────────────
  // Patient Auth (Phone + OTP)
  // ──────────────────────────────────────────────────────────

  /// Send OTP to a phone number. Phone must be in E.164 format (+880...).
  Future<void> sendOtp({required String phone}) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  /// Verify the OTP code. Returns the auth response.
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    return await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// Fetch the patient profile from the `profiles` table.
  Future<Map<String, dynamic>?> getPatientProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return data;
  }

  /// Create or update patient profile after first OTP verification.
  Future<void> upsertPatientProfile({
    required String userId,
    required String fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    await _client.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': 'patient',
    });
  }

  // ──────────────────────────────────────────────────────────
  // Doctor Auth (Email + Password)
  // ──────────────────────────────────────────────────────────

  /// Register a new doctor with email + password.
  Future<AuthResponse> signUpDoctor({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String nid,
    required String licenseNumber,
    required String specialization,
    required String hospital,
    required String department,
    required String degree,
    required String medicalCollege,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'role': 'doctor'},
    );

    if (response.user != null) {
      await createDoctorProfile(
        userId: response.user!.id,
        fullName: name,
        email: email,
        phone: phone,
        nid: nid,
        license: licenseNumber,
        specialization: specialization,
        hospital: hospital,
        department: department,
        degree: degree,
        medicalCollege: medicalCollege,
      );
    }

    return response;
  }

  /// Sign in a doctor with email + password.
  Future<AuthResponse> signInDoctor({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Fetch doctor profile from `doctors` table.
  Future<Map<String, dynamic>?> getDoctorProfile(String userId) async {
    final data = await _client
        .from('doctors')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return data;
  }

  /// Insert doctor profile row after signup.
  Future<void> createDoctorProfile({
    required String userId,
    required String fullName,
    required String email,
    String? phone,
    String? nid,
    String? license,
    String? specialization,
    String? hospital,
    String? department,
    String? degree,
    String? medicalCollege,
  }) async {
    await _client.from('doctors').insert({
      'id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'nid': nid,
      'license': license,
      'specialization': specialization,
      'hospital': hospital,
      'department': department,
      'degree': degree,
      'medical_college': medicalCollege,
    });
  }

  /// Update doctor profile fields.
  Future<void> updateDoctorProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _client.from('doctors').update(data).eq('id', userId);
  }

  /// Fetch all doctors (for patient browsing).
  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    final data = await _client.from('doctors').select().order('full_name');
    return List<Map<String, dynamic>>.from(data);
  }

  // ──────────────────────────────────────────────────────────
  // Common
  // ──────────────────────────────────────────────────────────

  /// Determine the user's role by checking both tables.
  Future<String?> getUserRole(String userId) async {
    // Check doctors table first
    final doctor = await _client
        .from('doctors')
        .select('id')
        .eq('id', userId)
        .maybeSingle();
    if (doctor != null) return 'doctor';

    // Then profiles
    final profile = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    if (profile != null) return profile['role'] as String?;

    return null;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Listen to auth state changes.
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}
