import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_profile.freezed.dart';
part 'doctor_profile.g.dart';

@freezed
sealed class DoctorProfile with _$DoctorProfile {
  const factory DoctorProfile({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    String? phone,
    String? nid,
    String? license,
    String? specialization,
    String? hospital,
    String? department,
    String? degree,
    @JsonKey(name: 'medical_college') String? medicalCollege,
    @Default('Dhaka') String location,
    String? description,
    @JsonKey(name: 'consultation_fee') @Default(500) int consultationFee,
    @Default('MediHub Centre') String diagnostic,
    String? experience,
    @JsonKey(name: 'profile_image') String? profileImage,
    @Default('doctor') String role,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DoctorProfile;

  factory DoctorProfile.fromJson(Map<String, dynamic> json) =>
      _$DoctorProfileFromJson(json);
}
