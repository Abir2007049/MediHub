import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor.freezed.dart';
part 'doctor.g.dart';

@freezed
class Doctor with _$Doctor {
  const factory Doctor({
    required int id,
    required String name,
    required String designation,
    @JsonKey(name: 'specialization_id') required int specializationId,
    @JsonKey(name: 'medical_college') required String medicalCollege,
    required String degree,
    required String description,
    required String email,
    @JsonKey(name: 'bmdc_reg') required String bmdcReg,
  }) = _Doctor;

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
}
