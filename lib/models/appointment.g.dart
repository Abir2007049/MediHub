// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Appointment _$AppointmentFromJson(Map<String, dynamic> json) => _Appointment(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  doctorId: (json['doctor_id'] as num).toInt(),
  chamberId: (json['chamber_id'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$AppointmentToJson(_Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'doctor_id': instance.doctorId,
      'chamber_id': instance.chamberId,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
    };
