// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Appointment _$AppointmentFromJson(Map<String, dynamic> json) => _Appointment(
  id: json['id'] as String?,
  patientId: json['patient_id'] as String,
  doctorId: json['doctor_id'] as String,
  patientName: json['patient_name'] as String?,
  patientMobile: json['patient_mobile'] as String?,
  doctorName: json['doctor_name'] as String?,
  specialization: json['specialization'] as String?,
  location: json['location'] as String?,
  selectedDay: json['selected_day'] as String,
  serialNumber: (json['serial_number'] as num).toInt(),
  approximateTime: json['approximate_time'] as String?,
  consultationFee: (json['consultation_fee'] as num?)?.toInt() ?? 500,
  paymentMethod: json['payment_method'] as String?,
  slotTime: json['slot_time'] == null
      ? null
      : DateTime.parse(json['slot_time'] as String),
  status: json['status'] as String? ?? 'confirmed',
  isFollowUp: json['is_follow_up'] as bool? ?? false,
  parentAppointmentId: json['parent_appointment_id'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AppointmentToJson(_Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'doctor_id': instance.doctorId,
      'patient_name': instance.patientName,
      'patient_mobile': instance.patientMobile,
      'doctor_name': instance.doctorName,
      'specialization': instance.specialization,
      'location': instance.location,
      'selected_day': instance.selectedDay,
      'serial_number': instance.serialNumber,
      'approximate_time': instance.approximateTime,
      'consultation_fee': instance.consultationFee,
      'payment_method': instance.paymentMethod,
      'slot_time': instance.slotTime?.toIso8601String(),
      'status': instance.status,
      'is_follow_up': instance.isFollowUp,
      'parent_appointment_id': instance.parentAppointmentId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
