// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String?,
  doctorId: json['doctor_id'] as String,
  patientId: json['patient_id'] as String,
  patientName: json['patient_name'] as String?,
  rating: (json['rating'] as num).toDouble(),
  comment: json['comment'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'doctor_id': instance.doctorId,
  'patient_id': instance.patientId,
  'patient_name': instance.patientName,
  'rating': instance.rating,
  'comment': instance.comment,
  'created_at': instance.createdAt?.toIso8601String(),
};
