// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medicine _$MedicineFromJson(Map<String, dynamic> json) => _Medicine(
  name: json['name'] as String,
  dose: json['dose'] as String? ?? '',
  timing: json['timing'] as String? ?? '',
);

Map<String, dynamic> _$MedicineToJson(_Medicine instance) => <String, dynamic>{
  'name': instance.name,
  'dose': instance.dose,
  'timing': instance.timing,
};
