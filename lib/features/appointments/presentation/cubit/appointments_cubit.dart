import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/features/appointments/data/repositories/appointment_repository.dart';
import 'package:medihub/features/prescription/data/repositories/prescription_repository.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentRepository _appointmentRepo;
  final PrescriptionRepository _prescriptionRepo;

  AppointmentsCubit({
    AppointmentRepository? appointmentRepo,
    PrescriptionRepository? prescriptionRepo,
  }) : _appointmentRepo = appointmentRepo ?? AppointmentRepository(),
       _prescriptionRepo = prescriptionRepo ?? PrescriptionRepository(),
       super(AppointmentsInitial());

  Future<void> loadPatientAppointments(String patientId) async {
    emit(AppointmentsLoading());
    try {
      final appointments = await _appointmentRepo.getPatientAppointments(
        patientId,
      );
      final ids = appointments
          .where((a) => a.id != null)
          .map((a) => a.id!)
          .toList();
      final prescriptions = await _prescriptionRepo
          .getPrescriptionsForAppointments(ids);
      emit(
        AppointmentsLoaded(
          appointments: appointments,
          prescriptions: prescriptions,
        ),
      );
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }

  Future<void> loadDoctorAppointments(String doctorId) async {
    emit(AppointmentsLoading());
    try {
      final appointments = await _appointmentRepo.getDoctorAppointments(
        doctorId,
      );
      final ids = appointments
          .where((a) => a.id != null)
          .map((a) => a.id!)
          .toList();
      final prescriptions = await _prescriptionRepo
          .getPrescriptionsForAppointments(ids);
      emit(
        AppointmentsLoaded(
          appointments: appointments,
          prescriptions: prescriptions,
        ),
      );
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }

  /// Reload after a prescription is saved, etc.
  Future<void> refresh() async {
    final current = state;
    if (current is AppointmentsLoaded && current.appointments.isNotEmpty) {
      // Determine if this was patient or doctor appointments
      // by checking if the first appointment has the same patient_id
      final firstAppt = current.appointments.first;
      final userId = firstAppt.patientId; // will re-query same userId
      await loadPatientAppointments(userId);
    }
  }
}


