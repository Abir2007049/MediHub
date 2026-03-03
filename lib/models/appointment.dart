import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'doctor_id') required int doctorId,
    @JsonKey(name: 'chamber_id') required int chamberId,
    required DateTime date,
    required String status,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
}
