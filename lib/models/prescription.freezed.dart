// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Prescription {

 String? get id;@JsonKey(name: 'appointment_id') String get appointmentId;@JsonKey(name: 'doctor_id') String get doctorId;@JsonKey(name: 'patient_id') String get patientId;@JsonKey(name: 'doctor_name') String? get doctorName;@JsonKey(name: 'doctor_specialization') String? get doctorSpecialization;@JsonKey(name: 'patient_name') String? get patientName;@JsonKey(name: 'patient_mobile') String? get patientMobile; List<Medicine> get medicines; List<String> get tests; String? get notes;@JsonKey(name: 'has_follow_up') bool get hasFollowUp;@JsonKey(name: 'follow_up_date') String? get followUpDate;@JsonKey(name: 'follow_up_fee') String? get followUpFee;@JsonKey(name: 'follow_up_booked') bool get followUpBooked;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionCopyWith<Prescription> get copyWith => _$PrescriptionCopyWithImpl<Prescription>(this as Prescription, _$identity);

  /// Serializes this Prescription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Prescription&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.doctorSpecialization, doctorSpecialization) || other.doctorSpecialization == doctorSpecialization)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientMobile, patientMobile) || other.patientMobile == patientMobile)&&const DeepCollectionEquality().equals(other.medicines, medicines)&&const DeepCollectionEquality().equals(other.tests, tests)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.hasFollowUp, hasFollowUp) || other.hasFollowUp == hasFollowUp)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.followUpFee, followUpFee) || other.followUpFee == followUpFee)&&(identical(other.followUpBooked, followUpBooked) || other.followUpBooked == followUpBooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,doctorId,patientId,doctorName,doctorSpecialization,patientName,patientMobile,const DeepCollectionEquality().hash(medicines),const DeepCollectionEquality().hash(tests),notes,hasFollowUp,followUpDate,followUpFee,followUpBooked,createdAt,updatedAt);

@override
String toString() {
  return 'Prescription(id: $id, appointmentId: $appointmentId, doctorId: $doctorId, patientId: $patientId, doctorName: $doctorName, doctorSpecialization: $doctorSpecialization, patientName: $patientName, patientMobile: $patientMobile, medicines: $medicines, tests: $tests, notes: $notes, hasFollowUp: $hasFollowUp, followUpDate: $followUpDate, followUpFee: $followUpFee, followUpBooked: $followUpBooked, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PrescriptionCopyWith<$Res>  {
  factory $PrescriptionCopyWith(Prescription value, $Res Function(Prescription) _then) = _$PrescriptionCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'appointment_id') String appointmentId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'doctor_name') String? doctorName,@JsonKey(name: 'doctor_specialization') String? doctorSpecialization,@JsonKey(name: 'patient_name') String? patientName,@JsonKey(name: 'patient_mobile') String? patientMobile, List<Medicine> medicines, List<String> tests, String? notes,@JsonKey(name: 'has_follow_up') bool hasFollowUp,@JsonKey(name: 'follow_up_date') String? followUpDate,@JsonKey(name: 'follow_up_fee') String? followUpFee,@JsonKey(name: 'follow_up_booked') bool followUpBooked,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$PrescriptionCopyWithImpl<$Res>
    implements $PrescriptionCopyWith<$Res> {
  _$PrescriptionCopyWithImpl(this._self, this._then);

  final Prescription _self;
  final $Res Function(Prescription) _then;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? appointmentId = null,Object? doctorId = null,Object? patientId = null,Object? doctorName = freezed,Object? doctorSpecialization = freezed,Object? patientName = freezed,Object? patientMobile = freezed,Object? medicines = null,Object? tests = null,Object? notes = freezed,Object? hasFollowUp = null,Object? followUpDate = freezed,Object? followUpFee = freezed,Object? followUpBooked = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,doctorSpecialization: freezed == doctorSpecialization ? _self.doctorSpecialization : doctorSpecialization // ignore: cast_nullable_to_non_nullable
as String?,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientMobile: freezed == patientMobile ? _self.patientMobile : patientMobile // ignore: cast_nullable_to_non_nullable
as String?,medicines: null == medicines ? _self.medicines : medicines // ignore: cast_nullable_to_non_nullable
as List<Medicine>,tests: null == tests ? _self.tests : tests // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,hasFollowUp: null == hasFollowUp ? _self.hasFollowUp : hasFollowUp // ignore: cast_nullable_to_non_nullable
as bool,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as String?,followUpFee: freezed == followUpFee ? _self.followUpFee : followUpFee // ignore: cast_nullable_to_non_nullable
as String?,followUpBooked: null == followUpBooked ? _self.followUpBooked : followUpBooked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Prescription].
extension PrescriptionPatterns on Prescription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Prescription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Prescription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Prescription value)  $default,){
final _that = this;
switch (_that) {
case _Prescription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Prescription value)?  $default,){
final _that = this;
switch (_that) {
case _Prescription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'appointment_id')  String appointmentId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_name')  String? doctorName, @JsonKey(name: 'doctor_specialization')  String? doctorSpecialization, @JsonKey(name: 'patient_name')  String? patientName, @JsonKey(name: 'patient_mobile')  String? patientMobile,  List<Medicine> medicines,  List<String> tests,  String? notes, @JsonKey(name: 'has_follow_up')  bool hasFollowUp, @JsonKey(name: 'follow_up_date')  String? followUpDate, @JsonKey(name: 'follow_up_fee')  String? followUpFee, @JsonKey(name: 'follow_up_booked')  bool followUpBooked, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Prescription() when $default != null:
return $default(_that.id,_that.appointmentId,_that.doctorId,_that.patientId,_that.doctorName,_that.doctorSpecialization,_that.patientName,_that.patientMobile,_that.medicines,_that.tests,_that.notes,_that.hasFollowUp,_that.followUpDate,_that.followUpFee,_that.followUpBooked,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'appointment_id')  String appointmentId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_name')  String? doctorName, @JsonKey(name: 'doctor_specialization')  String? doctorSpecialization, @JsonKey(name: 'patient_name')  String? patientName, @JsonKey(name: 'patient_mobile')  String? patientMobile,  List<Medicine> medicines,  List<String> tests,  String? notes, @JsonKey(name: 'has_follow_up')  bool hasFollowUp, @JsonKey(name: 'follow_up_date')  String? followUpDate, @JsonKey(name: 'follow_up_fee')  String? followUpFee, @JsonKey(name: 'follow_up_booked')  bool followUpBooked, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Prescription():
return $default(_that.id,_that.appointmentId,_that.doctorId,_that.patientId,_that.doctorName,_that.doctorSpecialization,_that.patientName,_that.patientMobile,_that.medicines,_that.tests,_that.notes,_that.hasFollowUp,_that.followUpDate,_that.followUpFee,_that.followUpBooked,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'appointment_id')  String appointmentId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_name')  String? doctorName, @JsonKey(name: 'doctor_specialization')  String? doctorSpecialization, @JsonKey(name: 'patient_name')  String? patientName, @JsonKey(name: 'patient_mobile')  String? patientMobile,  List<Medicine> medicines,  List<String> tests,  String? notes, @JsonKey(name: 'has_follow_up')  bool hasFollowUp, @JsonKey(name: 'follow_up_date')  String? followUpDate, @JsonKey(name: 'follow_up_fee')  String? followUpFee, @JsonKey(name: 'follow_up_booked')  bool followUpBooked, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Prescription() when $default != null:
return $default(_that.id,_that.appointmentId,_that.doctorId,_that.patientId,_that.doctorName,_that.doctorSpecialization,_that.patientName,_that.patientMobile,_that.medicines,_that.tests,_that.notes,_that.hasFollowUp,_that.followUpDate,_that.followUpFee,_that.followUpBooked,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Prescription implements Prescription {
  const _Prescription({this.id, @JsonKey(name: 'appointment_id') required this.appointmentId, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'patient_id') required this.patientId, @JsonKey(name: 'doctor_name') this.doctorName, @JsonKey(name: 'doctor_specialization') this.doctorSpecialization, @JsonKey(name: 'patient_name') this.patientName, @JsonKey(name: 'patient_mobile') this.patientMobile, final  List<Medicine> medicines = const [], final  List<String> tests = const [], this.notes, @JsonKey(name: 'has_follow_up') this.hasFollowUp = false, @JsonKey(name: 'follow_up_date') this.followUpDate, @JsonKey(name: 'follow_up_fee') this.followUpFee, @JsonKey(name: 'follow_up_booked') this.followUpBooked = false, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _medicines = medicines,_tests = tests;
  factory _Prescription.fromJson(Map<String, dynamic> json) => _$PrescriptionFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'appointment_id') final  String appointmentId;
@override@JsonKey(name: 'doctor_id') final  String doctorId;
@override@JsonKey(name: 'patient_id') final  String patientId;
@override@JsonKey(name: 'doctor_name') final  String? doctorName;
@override@JsonKey(name: 'doctor_specialization') final  String? doctorSpecialization;
@override@JsonKey(name: 'patient_name') final  String? patientName;
@override@JsonKey(name: 'patient_mobile') final  String? patientMobile;
 final  List<Medicine> _medicines;
@override@JsonKey() List<Medicine> get medicines {
  if (_medicines is EqualUnmodifiableListView) return _medicines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicines);
}

 final  List<String> _tests;
@override@JsonKey() List<String> get tests {
  if (_tests is EqualUnmodifiableListView) return _tests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tests);
}

@override final  String? notes;
@override@JsonKey(name: 'has_follow_up') final  bool hasFollowUp;
@override@JsonKey(name: 'follow_up_date') final  String? followUpDate;
@override@JsonKey(name: 'follow_up_fee') final  String? followUpFee;
@override@JsonKey(name: 'follow_up_booked') final  bool followUpBooked;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionCopyWith<_Prescription> get copyWith => __$PrescriptionCopyWithImpl<_Prescription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Prescription&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.doctorSpecialization, doctorSpecialization) || other.doctorSpecialization == doctorSpecialization)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientMobile, patientMobile) || other.patientMobile == patientMobile)&&const DeepCollectionEquality().equals(other._medicines, _medicines)&&const DeepCollectionEquality().equals(other._tests, _tests)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.hasFollowUp, hasFollowUp) || other.hasFollowUp == hasFollowUp)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.followUpFee, followUpFee) || other.followUpFee == followUpFee)&&(identical(other.followUpBooked, followUpBooked) || other.followUpBooked == followUpBooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,doctorId,patientId,doctorName,doctorSpecialization,patientName,patientMobile,const DeepCollectionEquality().hash(_medicines),const DeepCollectionEquality().hash(_tests),notes,hasFollowUp,followUpDate,followUpFee,followUpBooked,createdAt,updatedAt);

@override
String toString() {
  return 'Prescription(id: $id, appointmentId: $appointmentId, doctorId: $doctorId, patientId: $patientId, doctorName: $doctorName, doctorSpecialization: $doctorSpecialization, patientName: $patientName, patientMobile: $patientMobile, medicines: $medicines, tests: $tests, notes: $notes, hasFollowUp: $hasFollowUp, followUpDate: $followUpDate, followUpFee: $followUpFee, followUpBooked: $followUpBooked, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionCopyWith<$Res> implements $PrescriptionCopyWith<$Res> {
  factory _$PrescriptionCopyWith(_Prescription value, $Res Function(_Prescription) _then) = __$PrescriptionCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'appointment_id') String appointmentId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'doctor_name') String? doctorName,@JsonKey(name: 'doctor_specialization') String? doctorSpecialization,@JsonKey(name: 'patient_name') String? patientName,@JsonKey(name: 'patient_mobile') String? patientMobile, List<Medicine> medicines, List<String> tests, String? notes,@JsonKey(name: 'has_follow_up') bool hasFollowUp,@JsonKey(name: 'follow_up_date') String? followUpDate,@JsonKey(name: 'follow_up_fee') String? followUpFee,@JsonKey(name: 'follow_up_booked') bool followUpBooked,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$PrescriptionCopyWithImpl<$Res>
    implements _$PrescriptionCopyWith<$Res> {
  __$PrescriptionCopyWithImpl(this._self, this._then);

  final _Prescription _self;
  final $Res Function(_Prescription) _then;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? appointmentId = null,Object? doctorId = null,Object? patientId = null,Object? doctorName = freezed,Object? doctorSpecialization = freezed,Object? patientName = freezed,Object? patientMobile = freezed,Object? medicines = null,Object? tests = null,Object? notes = freezed,Object? hasFollowUp = null,Object? followUpDate = freezed,Object? followUpFee = freezed,Object? followUpBooked = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Prescription(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,doctorSpecialization: freezed == doctorSpecialization ? _self.doctorSpecialization : doctorSpecialization // ignore: cast_nullable_to_non_nullable
as String?,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientMobile: freezed == patientMobile ? _self.patientMobile : patientMobile // ignore: cast_nullable_to_non_nullable
as String?,medicines: null == medicines ? _self._medicines : medicines // ignore: cast_nullable_to_non_nullable
as List<Medicine>,tests: null == tests ? _self._tests : tests // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,hasFollowUp: null == hasFollowUp ? _self.hasFollowUp : hasFollowUp // ignore: cast_nullable_to_non_nullable
as bool,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as String?,followUpFee: freezed == followUpFee ? _self.followUpFee : followUpFee // ignore: cast_nullable_to_non_nullable
as String?,followUpBooked: null == followUpBooked ? _self.followUpBooked : followUpBooked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
