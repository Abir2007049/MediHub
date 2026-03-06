import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
sealed class Appointment with _$Appointment {
  const factory Appointment({
    String? id,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'patient_name') String? patientName,
    @JsonKey(name: 'patient_mobile') String? patientMobile,
    @JsonKey(name: 'doctor_name') String? doctorName,
    String? specialization,
    String? location,
    @JsonKey(name: 'selected_day') required String selectedDay,
    @JsonKey(name: 'serial_number') required int serialNumber,
    @JsonKey(name: 'approximate_time') String? approximateTime,
    @JsonKey(name: 'consultation_fee') @Default(500) int consultationFee,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'slot_time') DateTime? slotTime,
    @Default('confirmed') String status,
    @JsonKey(name: 'is_follow_up') @Default(false) bool isFollowUp,
    @JsonKey(name: 'parent_appointment_id') String? parentAppointmentId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}
