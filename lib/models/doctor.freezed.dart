// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Doctor {

 int get id; String get name; String get designation;@JsonKey(name: 'specialization_id') int get specializationId;@JsonKey(name: 'medical_college') String get medicalCollege; String get degree; String get description; String get email;@JsonKey(name: 'bmdc_reg') String get bmdcReg;
/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorCopyWith<Doctor> get copyWith => _$DoctorCopyWithImpl<Doctor>(this as Doctor, _$identity);

  /// Serializes this Doctor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Doctor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.medicalCollege, medicalCollege) || other.medicalCollege == medicalCollege)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.description, description) || other.description == description)&&(identical(other.email, email) || other.email == email)&&(identical(other.bmdcReg, bmdcReg) || other.bmdcReg == bmdcReg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,designation,specializationId,medicalCollege,degree,description,email,bmdcReg);

@override
String toString() {
  return 'Doctor(id: $id, name: $name, designation: $designation, specializationId: $specializationId, medicalCollege: $medicalCollege, degree: $degree, description: $description, email: $email, bmdcReg: $bmdcReg)';
}


}

/// @nodoc
abstract mixin class $DoctorCopyWith<$Res>  {
  factory $DoctorCopyWith(Doctor value, $Res Function(Doctor) _then) = _$DoctorCopyWithImpl;
@useResult
$Res call({
 int id, String name, String designation,@JsonKey(name: 'specialization_id') int specializationId,@JsonKey(name: 'medical_college') String medicalCollege, String degree, String description, String email,@JsonKey(name: 'bmdc_reg') String bmdcReg
});




}
/// @nodoc
class _$DoctorCopyWithImpl<$Res>
    implements $DoctorCopyWith<$Res> {
  _$DoctorCopyWithImpl(this._self, this._then);

  final Doctor _self;
  final $Res Function(Doctor) _then;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? designation = null,Object? specializationId = null,Object? medicalCollege = null,Object? degree = null,Object? description = null,Object? email = null,Object? bmdcReg = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,specializationId: null == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as int,medicalCollege: null == medicalCollege ? _self.medicalCollege : medicalCollege // ignore: cast_nullable_to_non_nullable
as String,degree: null == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,bmdcReg: null == bmdcReg ? _self.bmdcReg : bmdcReg // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Doctor].
extension DoctorPatterns on Doctor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Doctor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Doctor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Doctor value)  $default,){
final _that = this;
switch (_that) {
case _Doctor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Doctor value)?  $default,){
final _that = this;
switch (_that) {
case _Doctor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String designation, @JsonKey(name: 'specialization_id')  int specializationId, @JsonKey(name: 'medical_college')  String medicalCollege,  String degree,  String description,  String email, @JsonKey(name: 'bmdc_reg')  String bmdcReg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Doctor() when $default != null:
return $default(_that.id,_that.name,_that.designation,_that.specializationId,_that.medicalCollege,_that.degree,_that.description,_that.email,_that.bmdcReg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String designation, @JsonKey(name: 'specialization_id')  int specializationId, @JsonKey(name: 'medical_college')  String medicalCollege,  String degree,  String description,  String email, @JsonKey(name: 'bmdc_reg')  String bmdcReg)  $default,) {final _that = this;
switch (_that) {
case _Doctor():
return $default(_that.id,_that.name,_that.designation,_that.specializationId,_that.medicalCollege,_that.degree,_that.description,_that.email,_that.bmdcReg);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String designation, @JsonKey(name: 'specialization_id')  int specializationId, @JsonKey(name: 'medical_college')  String medicalCollege,  String degree,  String description,  String email, @JsonKey(name: 'bmdc_reg')  String bmdcReg)?  $default,) {final _that = this;
switch (_that) {
case _Doctor() when $default != null:
return $default(_that.id,_that.name,_that.designation,_that.specializationId,_that.medicalCollege,_that.degree,_that.description,_that.email,_that.bmdcReg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Doctor implements Doctor {
  const _Doctor({required this.id, required this.name, required this.designation, @JsonKey(name: 'specialization_id') required this.specializationId, @JsonKey(name: 'medical_college') required this.medicalCollege, required this.degree, required this.description, required this.email, @JsonKey(name: 'bmdc_reg') required this.bmdcReg});
  factory _Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

@override final  int id;
@override final  String name;
@override final  String designation;
@override@JsonKey(name: 'specialization_id') final  int specializationId;
@override@JsonKey(name: 'medical_college') final  String medicalCollege;
@override final  String degree;
@override final  String description;
@override final  String email;
@override@JsonKey(name: 'bmdc_reg') final  String bmdcReg;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorCopyWith<_Doctor> get copyWith => __$DoctorCopyWithImpl<_Doctor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Doctor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.medicalCollege, medicalCollege) || other.medicalCollege == medicalCollege)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.description, description) || other.description == description)&&(identical(other.email, email) || other.email == email)&&(identical(other.bmdcReg, bmdcReg) || other.bmdcReg == bmdcReg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,designation,specializationId,medicalCollege,degree,description,email,bmdcReg);

@override
String toString() {
  return 'Doctor(id: $id, name: $name, designation: $designation, specializationId: $specializationId, medicalCollege: $medicalCollege, degree: $degree, description: $description, email: $email, bmdcReg: $bmdcReg)';
}


}

/// @nodoc
abstract mixin class _$DoctorCopyWith<$Res> implements $DoctorCopyWith<$Res> {
  factory _$DoctorCopyWith(_Doctor value, $Res Function(_Doctor) _then) = __$DoctorCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String designation,@JsonKey(name: 'specialization_id') int specializationId,@JsonKey(name: 'medical_college') String medicalCollege, String degree, String description, String email,@JsonKey(name: 'bmdc_reg') String bmdcReg
});




}
/// @nodoc
class __$DoctorCopyWithImpl<$Res>
    implements _$DoctorCopyWith<$Res> {
  __$DoctorCopyWithImpl(this._self, this._then);

  final _Doctor _self;
  final $Res Function(_Doctor) _then;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? designation = null,Object? specializationId = null,Object? medicalCollege = null,Object? degree = null,Object? description = null,Object? email = null,Object? bmdcReg = null,}) {
  return _then(_Doctor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,specializationId: null == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as int,medicalCollege: null == medicalCollege ? _self.medicalCollege : medicalCollege // ignore: cast_nullable_to_non_nullable
as String,degree: null == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,bmdcReg: null == bmdcReg ? _self.bmdcReg : bmdcReg // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
