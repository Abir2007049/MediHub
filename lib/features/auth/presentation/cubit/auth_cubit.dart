import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/models/patient_profile.dart';
import 'package:medihub/features/doctor/data/repositories/doctor_repository.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SupabaseAuthService _auth;
  final DoctorRepository _doctorRepo;

  AuthCubit({SupabaseAuthService? auth, DoctorRepository? doctorRepo})
    : _auth = auth ?? sl<SupabaseAuthService>(),
      _doctorRepo = doctorRepo ?? sl<DoctorRepository>(),
      super(AuthInitial());

  String? get currentUserId => _auth.currentUser?.id;

  /// Check existing session and emit the right state.
  Future<void> checkSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(AuthUnauthenticated());
      return;
    }

    emit(AuthLoading());
    try {
      final role = await _auth.getUserRole(user.id);

      if (role == 'doctor') {
        final profile = await _doctorRepo.getDoctorById(user.id);
        if (profile != null) {
          emit(AuthenticatedAsDoctor(profile));
        } else {
          emit(AuthUnauthenticated());
        }
      } else if (role == 'patient') {
        final data = await _auth.getPatientProfile(user.id);
        if (data != null) {
          emit(AuthenticatedAsPatient(PatientProfile.fromJson(data)));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// After a patient completes OTP auth.
  void setPatientAuthenticated(PatientProfile profile) {
    emit(AuthenticatedAsPatient(profile));
  }

  /// After a doctor logs in.
  void setDoctorAuthenticated(DoctorProfile profile) {
    emit(AuthenticatedAsDoctor(profile));
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(AuthUnauthenticated());
  }
}
