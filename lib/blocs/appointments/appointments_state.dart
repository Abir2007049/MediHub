import '../../models/appointment.dart';
import '../../models/prescription.dart';

sealed class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;

  /// Map from appointment.id → Prescription (if one exists).
  final Map<String, Prescription> prescriptions;

  AppointmentsLoaded({required this.appointments, required this.prescriptions});
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}
