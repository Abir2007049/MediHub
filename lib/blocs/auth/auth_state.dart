import '../../models/doctor_profile.dart';
import '../../models/patient_profile.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthenticatedAsPatient extends AuthState {
  final PatientProfile profile;
  AuthenticatedAsPatient(this.profile);
}

class AuthenticatedAsDoctor extends AuthState {
  final DoctorProfile profile;
  AuthenticatedAsDoctor(this.profile);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
