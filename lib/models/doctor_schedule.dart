import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_schedule.freezed.dart';
part 'doctor_schedule.g.dart';

@freezed
sealed class DoctorSchedule with _$DoctorSchedule {
  const factory DoctorSchedule({
    String? id,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'day_of_week') required String dayOfWeek,
    @JsonKey(name: 'time_range') required String timeRange,
    @JsonKey(name: 'total_seats') @Default(30) int totalSeats,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DoctorSchedule;

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) =>
      _$DoctorScheduleFromJson(json);
}
