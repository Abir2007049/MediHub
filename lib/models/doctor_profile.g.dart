// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorProfile _$DoctorProfileFromJson(Map<String, dynamic> json) =>
    _DoctorProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      nid: json['nid'] as String?,
      license: json['license'] as String?,
      specialization: json['specialization'] as String?,
      hospital: json['hospital'] as String?,
      department: json['department'] as String?,
      degree: json['degree'] as String?,
      medicalCollege: json['medical_college'] as String?,
      location: json['location'] as String? ?? 'Dhaka',
      description: json['description'] as String?,
      consultationFee: (json['consultation_fee'] as num?)?.toInt() ?? 500,
      diagnostic: json['diagnostic'] as String? ?? 'MediHub Centre',
      experience: json['experience'] as String?,
      profileImage: json['profile_image'] as String?,
      role: json['role'] as String? ?? 'doctor',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DoctorProfileToJson(_DoctorProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'nid': instance.nid,
      'license': instance.license,
      'specialization': instance.specialization,
      'hospital': instance.hospital,
      'department': instance.department,
      'degree': instance.degree,
      'medical_college': instance.medicalCollege,
      'location': instance.location,
      'description': instance.description,
      'consultation_fee': instance.consultationFee,
      'diagnostic': instance.diagnostic,
      'experience': instance.experience,
      'profile_image': instance.profileImage,
      'role': instance.role,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
