// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Appointment {

 String? get id;@JsonKey(name: 'patient_id') String get patientId;@JsonKey(name: 'doctor_id') String get doctorId;@JsonKey(name: 'patient_name') String? get patientName;@JsonKey(name: 'patient_mobile') String? get patientMobile;@JsonKey(name: 'doctor_name') String? get doctorName; String? get specialization; String? get location;@JsonKey(name: 'selected_day') String get selectedDay;@JsonKey(name: 'serial_number') int get serialNumber;@JsonKey(name: 'approximate_time') String? get approximateTime;@JsonKey(name: 'consultation_fee') int get consultationFee;@JsonKey(name: 'payment_method') String? get paymentMethod;@JsonKey(name: 'slot_time') DateTime? get slotTime; String get status;@JsonKey(name: 'is_follow_up') bool get isFollowUp;@JsonKey(name: 'parent_appointment_id') String? get parentAppointmentId;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCopyWith<Appointment> get copyWith => _$AppointmentCopyWithImpl<Appointment>(this as Appointment, _$identity);

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientMobile, patientMobile) || other.patientMobile == patientMobile)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.location, location) || other.location == location)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.approximateTime, approximateTime) || other.approximateTime == approximateTime)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.slotTime, slotTime) || other.slotTime == slotTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFollowUp, isFollowUp) || other.isFollowUp == isFollowUp)&&(identical(other.parentAppointmentId, parentAppointmentId) || other.parentAppointmentId == parentAppointmentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,doctorId,patientName,patientMobile,doctorName,specialization,location,selectedDay,serialNumber,approximateTime,consultationFee,paymentMethod,slotTime,status,isFollowUp,parentAppointmentId,createdAt);

@override
String toString() {
  return 'Appointment(id: $id, patientId: $patientId, doctorId: $doctorId, patientName: $patientName, patientMobile: $patientMobile, doctorName: $doctorName, specialization: $specialization, location: $location, selectedDay: $selectedDay, serialNumber: $serialNumber, approximateTime: $approximateTime, consultationFee: $consultationFee, paymentMethod: $paymentMethod, slotTime: $slotTime, status: $status, isFollowUp: $isFollowUp, parentAppointmentId: $parentAppointmentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppointmentCopyWith<$Res>  {
  factory $AppointmentCopyWith(Appointment value, $Res Function(Appointment) _then) = _$AppointmentCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'patient_name') String? patientName,@JsonKey(name: 'patient_mobile') String? patientMobile,@JsonKey(name: 'doctor_name') String? doctorName, String? specialization, String? location,@JsonKey(name: 'selected_day') String selectedDay,@JsonKey(name: 'serial_number') int serialNumber,@JsonKey(name: 'approximate_time') String? approximateTime,@JsonKey(name: 'consultation_fee') int consultationFee,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'slot_time') DateTime? slotTime, String status,@JsonKey(name: 'is_follow_up') bool isFollowUp,@JsonKey(name: 'parent_appointment_id') String? parentAppointmentId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$AppointmentCopyWithImpl<$Res>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._self, this._then);

  final Appointment _self;
  final $Res Function(Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? patientId = null,Object? doctorId = null,Object? patientName = freezed,Object? patientMobile = freezed,Object? doctorName = freezed,Object? specialization = freezed,Object? location = freezed,Object? selectedDay = null,Object? serialNumber = null,Object? approximateTime = freezed,Object? consultationFee = null,Object? paymentMethod = freezed,Object? slotTime = freezed,Object? status = null,Object? isFollowUp = null,Object? parentAppointmentId = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientMobile: freezed == patientMobile ? _self.patientMobile : patientMobile // ignore: cast_nullable_to_non_nullable
as String?,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as int,approximateTime: freezed == approximateTime ? _self.approximateTime : approximateTime // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as int,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,slotTime: freezed == slotTime ? _self.slotTime : slotTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isFollowUp: null == isFollowUp ? _self.isFollowUp : isFollowUp // ignore: cast_nullable_to_non_nullable
as bool,parentAppointmentId: freezed == parentAppointmentId ? _self.parentAppointmentId : parentAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Appointment].
extension AppointmentPatterns on Appointment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointment value)  $default,){
final _that = this;
switch (_that) {
case _Appointment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointment value)?  $default,){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'patient_name')  String? patientName, @JsonKey(name: 'patient_mobile')  String? patientMobile, @JsonKey(name: 'doctor_name')  String? doctorName,  String? specialization,  String? location, @JsonKey(name: 'selected_day')  String selectedDay, @JsonKey(name: 'serial_number')  int serialNumber, @JsonKey(name: 'approximate_time')  String? approximateTime, @JsonKey(name: 'consultation_fee')  int consultationFee, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'slot_time')  DateTime? slotTime,  String status, @JsonKey(name: 'is_follow_up')  bool isFollowUp, @JsonKey(name: 'parent_appointment_id')  String? parentAppointmentId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.patientId,_that.doctorId,_that.patientName,_that.patientMobile,_that.doctorName,_that.specialization,_that.location,_that.selectedDay,_that.serialNumber,_that.approximateTime,_that.consultationFee,_that.paymentMethod,_that.slotTime,_that.status,_that.isFollowUp,_that.parentAppointmentId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'patient_name')  String? patientName, @JsonKey(name: 'patient_mobile')  String? patientMobile, @JsonKey(name: 'doctor_name')  String? doctorName,  String? specialization,  String? location, @JsonKey(name: 'selected_day')  String selectedDay, @JsonKey(name: 'serial_number')  int serialNumber, @JsonKey(name: 'approximate_time')  String? approximateTime, @JsonKey(name: 'consultation_fee')  int consultationFee, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'slot_time')  DateTime? slotTime,  String status, @JsonKey(name: 'is_follow_up')  bool isFollowUp, @JsonKey(name: 'parent_appointment_id')  String? parentAppointmentId, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Appointment():
return $default(_that.id,_that.patientId,_that.doctorId,_that.patientName,_that.patientMobile,_that.doctorName,_that.specialization,_that.location,_that.selectedDay,_that.serialNumber,_that.approximateTime,_that.consultationFee,_that.paymentMethod,_that.slotTime,_that.status,_that.isFollowUp,_that.parentAppointmentId,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'patient_name')  String? patientName, @JsonKey(name: 'patient_mobile')  String? patientMobile, @JsonKey(name: 'doctor_name')  String? doctorName,  String? specialization,  String? location, @JsonKey(name: 'selected_day')  String selectedDay, @JsonKey(name: 'serial_number')  int serialNumber, @JsonKey(name: 'approximate_time')  String? approximateTime, @JsonKey(name: 'consultation_fee')  int consultationFee, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'slot_time')  DateTime? slotTime,  String status, @JsonKey(name: 'is_follow_up')  bool isFollowUp, @JsonKey(name: 'parent_appointment_id')  String? parentAppointmentId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.patientId,_that.doctorId,_that.patientName,_that.patientMobile,_that.doctorName,_that.specialization,_that.location,_that.selectedDay,_that.serialNumber,_that.approximateTime,_that.consultationFee,_that.paymentMethod,_that.slotTime,_that.status,_that.isFollowUp,_that.parentAppointmentId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointment implements Appointment {
  const _Appointment({this.id, @JsonKey(name: 'patient_id') required this.patientId, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'patient_name') this.patientName, @JsonKey(name: 'patient_mobile') this.patientMobile, @JsonKey(name: 'doctor_name') this.doctorName, this.specialization, this.location, @JsonKey(name: 'selected_day') required this.selectedDay, @JsonKey(name: 'serial_number') required this.serialNumber, @JsonKey(name: 'approximate_time') this.approximateTime, @JsonKey(name: 'consultation_fee') this.consultationFee = 500, @JsonKey(name: 'payment_method') this.paymentMethod, @JsonKey(name: 'slot_time') this.slotTime, this.status = 'confirmed', @JsonKey(name: 'is_follow_up') this.isFollowUp = false, @JsonKey(name: 'parent_appointment_id') this.parentAppointmentId, @JsonKey(name: 'created_at') this.createdAt});
  factory _Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'patient_id') final  String patientId;
@override@JsonKey(name: 'doctor_id') final  String doctorId;
@override@JsonKey(name: 'patient_name') final  String? patientName;
@override@JsonKey(name: 'patient_mobile') final  String? patientMobile;
@override@JsonKey(name: 'doctor_name') final  String? doctorName;
@override final  String? specialization;
@override final  String? location;
@override@JsonKey(name: 'selected_day') final  String selectedDay;
@override@JsonKey(name: 'serial_number') final  int serialNumber;
@override@JsonKey(name: 'approximate_time') final  String? approximateTime;
@override@JsonKey(name: 'consultation_fee') final  int consultationFee;
@override@JsonKey(name: 'payment_method') final  String? paymentMethod;
@override@JsonKey(name: 'slot_time') final  DateTime? slotTime;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'is_follow_up') final  bool isFollowUp;
@override@JsonKey(name: 'parent_appointment_id') final  String? parentAppointmentId;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentCopyWith<_Appointment> get copyWith => __$AppointmentCopyWithImpl<_Appointment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientMobile, patientMobile) || other.patientMobile == patientMobile)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.location, location) || other.location == location)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.approximateTime, approximateTime) || other.approximateTime == approximateTime)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.slotTime, slotTime) || other.slotTime == slotTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFollowUp, isFollowUp) || other.isFollowUp == isFollowUp)&&(identical(other.parentAppointmentId, parentAppointmentId) || other.parentAppointmentId == parentAppointmentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,doctorId,patientName,patientMobile,doctorName,specialization,location,selectedDay,serialNumber,approximateTime,consultationFee,paymentMethod,slotTime,status,isFollowUp,parentAppointmentId,createdAt);

@override
String toString() {
  return 'Appointment(id: $id, patientId: $patientId, doctorId: $doctorId, patientName: $patientName, patientMobile: $patientMobile, doctorName: $doctorName, specialization: $specialization, location: $location, selectedDay: $selectedDay, serialNumber: $serialNumber, approximateTime: $approximateTime, consultationFee: $consultationFee, paymentMethod: $paymentMethod, slotTime: $slotTime, status: $status, isFollowUp: $isFollowUp, parentAppointmentId: $parentAppointmentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppointmentCopyWith<$Res> implements $AppointmentCopyWith<$Res> {
  factory _$AppointmentCopyWith(_Appointment value, $Res Function(_Appointment) _then) = __$AppointmentCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'patient_name') String? patientName,@JsonKey(name: 'patient_mobile') String? patientMobile,@JsonKey(name: 'doctor_name') String? doctorName, String? specialization, String? location,@JsonKey(name: 'selected_day') String selectedDay,@JsonKey(name: 'serial_number') int serialNumber,@JsonKey(name: 'approximate_time') String? approximateTime,@JsonKey(name: 'consultation_fee') int consultationFee,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'slot_time') DateTime? slotTime, String status,@JsonKey(name: 'is_follow_up') bool isFollowUp,@JsonKey(name: 'parent_appointment_id') String? parentAppointmentId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$AppointmentCopyWithImpl<$Res>
    implements _$AppointmentCopyWith<$Res> {
  __$AppointmentCopyWithImpl(this._self, this._then);

  final _Appointment _self;
  final $Res Function(_Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? patientId = null,Object? doctorId = null,Object? patientName = freezed,Object? patientMobile = freezed,Object? doctorName = freezed,Object? specialization = freezed,Object? location = freezed,Object? selectedDay = null,Object? serialNumber = null,Object? approximateTime = freezed,Object? consultationFee = null,Object? paymentMethod = freezed,Object? slotTime = freezed,Object? status = null,Object? isFollowUp = null,Object? parentAppointmentId = freezed,Object? createdAt = freezed,}) {
  return _then(_Appointment(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientMobile: freezed == patientMobile ? _self.patientMobile : patientMobile // ignore: cast_nullable_to_non_nullable
as String?,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as int,approximateTime: freezed == approximateTime ? _self.approximateTime : approximateTime // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as int,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,slotTime: freezed == slotTime ? _self.slotTime : slotTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isFollowUp: null == isFollowUp ? _self.isFollowUp : isFollowUp // ignore: cast_nullable_to_non_nullable
as bool,parentAppointmentId: freezed == parentAppointmentId ? _self.parentAppointmentId : parentAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
