// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorSchedule _$DoctorScheduleFromJson(Map<String, dynamic> json) =>
    _DoctorSchedule(
      id: json['id'] as String?,
      doctorId: json['doctor_id'] as String,
      dayOfWeek: json['day_of_week'] as String,
      timeRange: json['time_range'] as String,
      totalSeats: (json['total_seats'] as num?)?.toInt() ?? 30,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DoctorScheduleToJson(_DoctorSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor_id': instance.doctorId,
      'day_of_week': instance.dayOfWeek,
      'time_range': instance.timeRange,
      'total_seats': instance.totalSeats,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
