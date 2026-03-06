import 'package:freezed_annotation/freezed_annotation.dart';
import 'medicine.dart';

part 'prescription.freezed.dart';
part 'prescription.g.dart';

@freezed
sealed class Prescription with _$Prescription {
  const factory Prescription({
    String? id,
    @JsonKey(name: 'appointment_id') required String appointmentId,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'doctor_name') String? doctorName,
    @JsonKey(name: 'doctor_specialization') String? doctorSpecialization,
    @JsonKey(name: 'patient_name') String? patientName,
    @JsonKey(name: 'patient_mobile') String? patientMobile,
    @Default([]) List<Medicine> medicines,
    @Default([]) List<String> tests,
    String? notes,
    @JsonKey(name: 'has_follow_up') @Default(false) bool hasFollowUp,
    @JsonKey(name: 'follow_up_date') String? followUpDate,
    @JsonKey(name: 'follow_up_fee') String? followUpFee,
    @JsonKey(name: 'follow_up_booked') @Default(false) bool followUpBooked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Prescription;

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
}
