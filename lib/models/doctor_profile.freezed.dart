// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoctorProfile {

 String get id;@JsonKey(name: 'full_name') String get fullName; String get email; String? get phone; String? get nid; String? get license; String? get specialization; String? get hospital; String? get department; String? get degree;@JsonKey(name: 'medical_college') String? get medicalCollege; String get location; String? get description;@JsonKey(name: 'consultation_fee') int get consultationFee; String get diagnostic; String? get experience;@JsonKey(name: 'profile_image') String? get profileImage; String get role;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of DoctorProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorProfileCopyWith<DoctorProfile> get copyWith => _$DoctorProfileCopyWithImpl<DoctorProfile>(this as DoctorProfile, _$identity);

  /// Serializes this DoctorProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.license, license) || other.license == license)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.department, department) || other.department == department)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.medicalCollege, medicalCollege) || other.medicalCollege == medicalCollege)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.diagnostic, diagnostic) || other.diagnostic == diagnostic)&&(identical(other.experience, experience) || other.experience == experience)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,fullName,email,phone,nid,license,specialization,hospital,department,degree,medicalCollege,location,description,consultationFee,diagnostic,experience,profileImage,role,createdAt,updatedAt]);

@override
String toString() {
  return 'DoctorProfile(id: $id, fullName: $fullName, email: $email, phone: $phone, nid: $nid, license: $license, specialization: $specialization, hospital: $hospital, department: $department, degree: $degree, medicalCollege: $medicalCollege, location: $location, description: $description, consultationFee: $consultationFee, diagnostic: $diagnostic, experience: $experience, profileImage: $profileImage, role: $role, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DoctorProfileCopyWith<$Res>  {
  factory $DoctorProfileCopyWith(DoctorProfile value, $Res Function(DoctorProfile) _then) = _$DoctorProfileCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName, String email, String? phone, String? nid, String? license, String? specialization, String? hospital, String? department, String? degree,@JsonKey(name: 'medical_college') String? medicalCollege, String location, String? description,@JsonKey(name: 'consultation_fee') int consultationFee, String diagnostic, String? experience,@JsonKey(name: 'profile_image') String? profileImage, String role,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$DoctorProfileCopyWithImpl<$Res>
    implements $DoctorProfileCopyWith<$Res> {
  _$DoctorProfileCopyWithImpl(this._self, this._then);

  final DoctorProfile _self;
  final $Res Function(DoctorProfile) _then;

/// Create a copy of DoctorProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? email = null,Object? phone = freezed,Object? nid = freezed,Object? license = freezed,Object? specialization = freezed,Object? hospital = freezed,Object? department = freezed,Object? degree = freezed,Object? medicalCollege = freezed,Object? location = null,Object? description = freezed,Object? consultationFee = null,Object? diagnostic = null,Object? experience = freezed,Object? profileImage = freezed,Object? role = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,nid: freezed == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String?,license: freezed == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,hospital: freezed == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,degree: freezed == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String?,medicalCollege: freezed == medicalCollege ? _self.medicalCollege : medicalCollege // ignore: cast_nullable_to_non_nullable
as String?,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as int,diagnostic: null == diagnostic ? _self.diagnostic : diagnostic // ignore: cast_nullable_to_non_nullable
as String,experience: freezed == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DoctorProfile].
extension DoctorProfilePatterns on DoctorProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoctorProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoctorProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoctorProfile value)  $default,){
final _that = this;
switch (_that) {
case _DoctorProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoctorProfile value)?  $default,){
final _that = this;
switch (_that) {
case _DoctorProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName,  String email,  String? phone,  String? nid,  String? license,  String? specialization,  String? hospital,  String? department,  String? degree, @JsonKey(name: 'medical_college')  String? medicalCollege,  String location,  String? description, @JsonKey(name: 'consultation_fee')  int consultationFee,  String diagnostic,  String? experience, @JsonKey(name: 'profile_image')  String? profileImage,  String role, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoctorProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.nid,_that.license,_that.specialization,_that.hospital,_that.department,_that.degree,_that.medicalCollege,_that.location,_that.description,_that.consultationFee,_that.diagnostic,_that.experience,_that.profileImage,_that.role,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName,  String email,  String? phone,  String? nid,  String? license,  String? specialization,  String? hospital,  String? department,  String? degree, @JsonKey(name: 'medical_college')  String? medicalCollege,  String location,  String? description, @JsonKey(name: 'consultation_fee')  int consultationFee,  String diagnostic,  String? experience, @JsonKey(name: 'profile_image')  String? profileImage,  String role, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DoctorProfile():
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.nid,_that.license,_that.specialization,_that.hospital,_that.department,_that.degree,_that.medicalCollege,_that.location,_that.description,_that.consultationFee,_that.diagnostic,_that.experience,_that.profileImage,_that.role,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String fullName,  String email,  String? phone,  String? nid,  String? license,  String? specialization,  String? hospital,  String? department,  String? degree, @JsonKey(name: 'medical_college')  String? medicalCollege,  String location,  String? description, @JsonKey(name: 'consultation_fee')  int consultationFee,  String diagnostic,  String? experience, @JsonKey(name: 'profile_image')  String? profileImage,  String role, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DoctorProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.nid,_that.license,_that.specialization,_that.hospital,_that.department,_that.degree,_that.medicalCollege,_that.location,_that.description,_that.consultationFee,_that.diagnostic,_that.experience,_that.profileImage,_that.role,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoctorProfile implements DoctorProfile {
  const _DoctorProfile({required this.id, @JsonKey(name: 'full_name') required this.fullName, required this.email, this.phone, this.nid, this.license, this.specialization, this.hospital, this.department, this.degree, @JsonKey(name: 'medical_college') this.medicalCollege, this.location = 'Dhaka', this.description, @JsonKey(name: 'consultation_fee') this.consultationFee = 500, this.diagnostic = 'MediHub Centre', this.experience, @JsonKey(name: 'profile_image') this.profileImage, this.role = 'doctor', @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _DoctorProfile.fromJson(Map<String, dynamic> json) => _$DoctorProfileFromJson(json);

@override final  String id;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String email;
@override final  String? phone;
@override final  String? nid;
@override final  String? license;
@override final  String? specialization;
@override final  String? hospital;
@override final  String? department;
@override final  String? degree;
@override@JsonKey(name: 'medical_college') final  String? medicalCollege;
@override@JsonKey() final  String location;
@override final  String? description;
@override@JsonKey(name: 'consultation_fee') final  int consultationFee;
@override@JsonKey() final  String diagnostic;
@override final  String? experience;
@override@JsonKey(name: 'profile_image') final  String? profileImage;
@override@JsonKey() final  String role;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of DoctorProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorProfileCopyWith<_DoctorProfile> get copyWith => __$DoctorProfileCopyWithImpl<_DoctorProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.license, license) || other.license == license)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.department, department) || other.department == department)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.medicalCollege, medicalCollege) || other.medicalCollege == medicalCollege)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.diagnostic, diagnostic) || other.diagnostic == diagnostic)&&(identical(other.experience, experience) || other.experience == experience)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,fullName,email,phone,nid,license,specialization,hospital,department,degree,medicalCollege,location,description,consultationFee,diagnostic,experience,profileImage,role,createdAt,updatedAt]);

@override
String toString() {
  return 'DoctorProfile(id: $id, fullName: $fullName, email: $email, phone: $phone, nid: $nid, license: $license, specialization: $specialization, hospital: $hospital, department: $department, degree: $degree, medicalCollege: $medicalCollege, location: $location, description: $description, consultationFee: $consultationFee, diagnostic: $diagnostic, experience: $experience, profileImage: $profileImage, role: $role, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DoctorProfileCopyWith<$Res> implements $DoctorProfileCopyWith<$Res> {
  factory _$DoctorProfileCopyWith(_DoctorProfile value, $Res Function(_DoctorProfile) _then) = __$DoctorProfileCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName, String email, String? phone, String? nid, String? license, String? specialization, String? hospital, String? department, String? degree,@JsonKey(name: 'medical_college') String? medicalCollege, String location, String? description,@JsonKey(name: 'consultation_fee') int consultationFee, String diagnostic, String? experience,@JsonKey(name: 'profile_image') String? profileImage, String role,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$DoctorProfileCopyWithImpl<$Res>
    implements _$DoctorProfileCopyWith<$Res> {
  __$DoctorProfileCopyWithImpl(this._self, this._then);

  final _DoctorProfile _self;
  final $Res Function(_DoctorProfile) _then;

/// Create a copy of DoctorProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = null,Object? phone = freezed,Object? nid = freezed,Object? license = freezed,Object? specialization = freezed,Object? hospital = freezed,Object? department = freezed,Object? degree = freezed,Object? medicalCollege = freezed,Object? location = null,Object? description = freezed,Object? consultationFee = null,Object? diagnostic = null,Object? experience = freezed,Object? profileImage = freezed,Object? role = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_DoctorProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,nid: freezed == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String?,license: freezed == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,hospital: freezed == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,degree: freezed == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String?,medicalCollege: freezed == medicalCollege ? _self.medicalCollege : medicalCollege // ignore: cast_nullable_to_non_nullable
as String?,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as int,diagnostic: null == diagnostic ? _self.diagnostic : diagnostic // ignore: cast_nullable_to_non_nullable
as String,experience: freezed == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
