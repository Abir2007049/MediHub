import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine.freezed.dart';
part 'medicine.g.dart';

@freezed
sealed class Medicine with _$Medicine {
  const factory Medicine({
    required String name,
    @Default('') String dose,
    @Default('') String timing,
  }) = _Medicine;

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);
}
