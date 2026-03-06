// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Doctor _$DoctorFromJson(Map<String, dynamic> json) => _Doctor(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  designation: json['designation'] as String,
  specializationId: (json['specialization_id'] as num).toInt(),
  medicalCollege: json['medical_college'] as String,
  degree: json['degree'] as String,
  description: json['description'] as String,
  email: json['email'] as String,
  bmdcReg: json['bmdc_reg'] as String,
);

Map<String, dynamic> _$DoctorToJson(_Doctor instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'designation': instance.designation,
  'specialization_id': instance.specializationId,
  'medical_college': instance.medicalCollege,
  'degree': instance.degree,
  'description': instance.description,
  'email': instance.email,
  'bmdc_reg': instance.bmdcReg,
};
