import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
sealed class Review with _$Review {
  const factory Review({
    String? id,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'patient_name') String? patientName,
    required double rating,
    String? comment,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
