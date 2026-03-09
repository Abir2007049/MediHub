import '../../models/doctor_profile.dart';

sealed class DoctorListState {}

class DoctorListInitial extends DoctorListState {}

class DoctorListLoading extends DoctorListState {}

class DoctorListLoaded extends DoctorListState {
  final List<DoctorProfile> doctors;
  final List<String> specializations;
  final List<String> locations;
  final Map<String, double> doctorRatings;

  DoctorListLoaded({
    required this.doctors,
    required this.specializations,
    required this.locations,
    required this.doctorRatings,
  });
}

class DoctorListError extends DoctorListState {
  final String message;
  DoctorListError(this.message);
}
