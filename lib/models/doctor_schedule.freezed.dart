// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoctorSchedule {

 String? get id;@JsonKey(name: 'doctor_id') String get doctorId;@JsonKey(name: 'day_of_week') String get dayOfWeek;@JsonKey(name: 'time_range') String get timeRange;@JsonKey(name: 'total_seats') int get totalSeats;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorScheduleCopyWith<DoctorSchedule> get copyWith => _$DoctorScheduleCopyWithImpl<DoctorSchedule>(this as DoctorSchedule, _$identity);

  /// Serializes this DoctorSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.totalSeats, totalSeats) || other.totalSeats == totalSeats)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,dayOfWeek,timeRange,totalSeats,createdAt,updatedAt);

@override
String toString() {
  return 'DoctorSchedule(id: $id, doctorId: $doctorId, dayOfWeek: $dayOfWeek, timeRange: $timeRange, totalSeats: $totalSeats, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DoctorScheduleCopyWith<$Res>  {
  factory $DoctorScheduleCopyWith(DoctorSchedule value, $Res Function(DoctorSchedule) _then) = _$DoctorScheduleCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'day_of_week') String dayOfWeek,@JsonKey(name: 'time_range') String timeRange,@JsonKey(name: 'total_seats') int totalSeats,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$DoctorScheduleCopyWithImpl<$Res>
    implements $DoctorScheduleCopyWith<$Res> {
  _$DoctorScheduleCopyWithImpl(this._self, this._then);

  final DoctorSchedule _self;
  final $Res Function(DoctorSchedule) _then;

/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? doctorId = null,Object? dayOfWeek = null,Object? timeRange = null,Object? totalSeats = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as String,totalSeats: null == totalSeats ? _self.totalSeats : totalSeats // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DoctorSchedule].
extension DoctorSchedulePatterns on DoctorSchedule {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoctorSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoctorSchedule value)  $default,){
final _that = this;
switch (_that) {
case _DoctorSchedule():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoctorSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'day_of_week')  String dayOfWeek, @JsonKey(name: 'time_range')  String timeRange, @JsonKey(name: 'total_seats')  int totalSeats, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
return $default(_that.id,_that.doctorId,_that.dayOfWeek,_that.timeRange,_that.totalSeats,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'day_of_week')  String dayOfWeek, @JsonKey(name: 'time_range')  String timeRange, @JsonKey(name: 'total_seats')  int totalSeats, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DoctorSchedule():
return $default(_that.id,_that.doctorId,_that.dayOfWeek,_that.timeRange,_that.totalSeats,_that.createdAt,_that.updatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'day_of_week')  String dayOfWeek, @JsonKey(name: 'time_range')  String timeRange, @JsonKey(name: 'total_seats')  int totalSeats, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
return $default(_that.id,_that.doctorId,_that.dayOfWeek,_that.timeRange,_that.totalSeats,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoctorSchedule implements DoctorSchedule {
  const _DoctorSchedule({this.id, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'day_of_week') required this.dayOfWeek, @JsonKey(name: 'time_range') required this.timeRange, @JsonKey(name: 'total_seats') this.totalSeats = 30, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _DoctorSchedule.fromJson(Map<String, dynamic> json) => _$DoctorScheduleFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'doctor_id') final  String doctorId;
@override@JsonKey(name: 'day_of_week') final  String dayOfWeek;
@override@JsonKey(name: 'time_range') final  String timeRange;
@override@JsonKey(name: 'total_seats') final  int totalSeats;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorScheduleCopyWith<_DoctorSchedule> get copyWith => __$DoctorScheduleCopyWithImpl<_DoctorSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.totalSeats, totalSeats) || other.totalSeats == totalSeats)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,dayOfWeek,timeRange,totalSeats,createdAt,updatedAt);

@override
String toString() {
  return 'DoctorSchedule(id: $id, doctorId: $doctorId, dayOfWeek: $dayOfWeek, timeRange: $timeRange, totalSeats: $totalSeats, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DoctorScheduleCopyWith<$Res> implements $DoctorScheduleCopyWith<$Res> {
  factory _$DoctorScheduleCopyWith(_DoctorSchedule value, $Res Function(_DoctorSchedule) _then) = __$DoctorScheduleCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'day_of_week') String dayOfWeek,@JsonKey(name: 'time_range') String timeRange,@JsonKey(name: 'total_seats') int totalSeats,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$DoctorScheduleCopyWithImpl<$Res>
    implements _$DoctorScheduleCopyWith<$Res> {
  __$DoctorScheduleCopyWithImpl(this._self, this._then);

  final _DoctorSchedule _self;
  final $Res Function(_DoctorSchedule) _then;

/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? doctorId = null,Object? dayOfWeek = null,Object? timeRange = null,Object? totalSeats = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_DoctorSchedule(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as String,totalSeats: null == totalSeats ? _self.totalSeats : totalSeats // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
