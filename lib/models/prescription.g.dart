// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Prescription _$PrescriptionFromJson(Map<String, dynamic> json) =>
    _Prescription(
      id: json['id'] as String?,
      appointmentId: json['appointment_id'] as String,
      doctorId: json['doctor_id'] as String,
      patientId: json['patient_id'] as String,
      doctorName: json['doctor_name'] as String?,
      doctorSpecialization: json['doctor_specialization'] as String?,
      patientName: json['patient_name'] as String?,
      patientMobile: json['patient_mobile'] as String?,
      medicines:
          (json['medicines'] as List<dynamic>?)
              ?.map((e) => Medicine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tests:
          (json['tests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      notes: json['notes'] as String?,
      hasFollowUp: json['has_follow_up'] as bool? ?? false,
      followUpDate: json['follow_up_date'] as String?,
      followUpFee: json['follow_up_fee'] as String?,
      followUpBooked: json['follow_up_booked'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PrescriptionToJson(_Prescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointment_id': instance.appointmentId,
      'doctor_id': instance.doctorId,
      'patient_id': instance.patientId,
      'doctor_name': instance.doctorName,
      'doctor_specialization': instance.doctorSpecialization,
      'patient_name': instance.patientName,
      'patient_mobile': instance.patientMobile,
      'medicines': instance.medicines,
      'tests': instance.tests,
      'notes': instance.notes,
      'has_follow_up': instance.hasFollowUp,
      'follow_up_date': instance.followUpDate,
      'follow_up_fee': instance.followUpFee,
      'follow_up_booked': instance.followUpBooked,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
