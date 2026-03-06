import '../../models/doctor_profile.dart';

sealed class DoctorProfileState {}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoading extends DoctorProfileState {}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorProfile profile;
  DoctorProfileLoaded(this.profile);
}

class DoctorProfileSaving extends DoctorProfileState {}

class DoctorProfileSaved extends DoctorProfileState {
  final DoctorProfile profile;
  DoctorProfileSaved(this.profile);
}

class DoctorProfileError extends DoctorProfileState {
  final String message;
  DoctorProfileError(this.message);
}
