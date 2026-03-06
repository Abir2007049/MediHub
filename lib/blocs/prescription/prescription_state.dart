import '../../models/prescription.dart';

sealed class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionLoaded extends PrescriptionState {
  final Prescription prescription;
  PrescriptionLoaded(this.prescription);
}

class PrescriptionNotFound extends PrescriptionState {}

class PrescriptionSaving extends PrescriptionState {}

class PrescriptionSaved extends PrescriptionState {
  final Prescription prescription;
  PrescriptionSaved(this.prescription);
}

class PrescriptionError extends PrescriptionState {
  final String message;
  PrescriptionError(this.message);
}
