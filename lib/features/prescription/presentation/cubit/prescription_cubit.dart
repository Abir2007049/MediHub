import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/models/prescription.dart';
import 'package:medihub/models/medicine.dart';
import 'package:medihub/features/prescription/data/repositories/prescription_repository.dart';
import 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final PrescriptionRepository _repo;

  PrescriptionCubit({PrescriptionRepository? repo})
    : _repo = repo ?? PrescriptionRepository(),
      super(PrescriptionInitial());

  Future<void> loadByAppointmentId(String appointmentId) async {
    emit(PrescriptionLoading());
    try {
      final p = await _repo.getByAppointmentId(appointmentId);
      if (p != null) {
        emit(PrescriptionLoaded(p));
      } else {
        emit(PrescriptionNotFound());
      }
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> savePrescription({
    required String appointmentId,
    required String doctorId,
    required String patientId,
    String? doctorName,
    String? doctorSpecialization,
    String? patientName,
    String? patientMobile,
    required List<Medicine> medicines,
    required List<String> tests,
    String? notes,
    bool hasFollowUp = false,
    String? followUpDate,
    String? followUpFee,
    String? existingId,
  }) async {
    emit(PrescriptionSaving());
    try {
      late final Prescription prescription;
      if (existingId != null) {
        prescription = await _repo.updatePrescription(
          existingId,
          medicines: medicines,
          tests: tests,
          notes: notes,
          hasFollowUp: hasFollowUp,
          followUpDate: followUpDate,
          followUpFee: followUpFee,
        );
      } else {
        prescription = await _repo.createPrescription(
          appointmentId: appointmentId,
          doctorId: doctorId,
          patientId: patientId,
          doctorName: doctorName,
          doctorSpecialization: doctorSpecialization,
          patientName: patientName,
          patientMobile: patientMobile,
          medicines: medicines,
          tests: tests,
          notes: notes,
          hasFollowUp: hasFollowUp,
          followUpDate: followUpDate,
          followUpFee: followUpFee,
        );
      }
      emit(PrescriptionSaved(prescription));
      emit(PrescriptionLoaded(prescription));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> markFollowUpBooked(String prescriptionId) async {
    try {
      await _repo.markFollowUpBooked(prescriptionId);
      final current = state;
      if (current is PrescriptionLoaded) {
        emit(
          PrescriptionLoaded(
            current.prescription.copyWith(followUpBooked: true),
          ),
        );
      }
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }
}


