// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientProfile _$PatientProfileFromJson(Map<String, dynamic> json) =>
    _PatientProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'patient',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PatientProfileToJson(_PatientProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'role': instance.role,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
