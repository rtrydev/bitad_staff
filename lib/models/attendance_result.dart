import 'package:json_annotation/json_annotation.dart';

part 'attendance_result.g.dart';

@JsonSerializable()
class AttendanceResult {
  final int code;
  final String message;

  AttendanceResult({required this.code, required this.message});

  factory AttendanceResult.fromJson(Map<String, dynamic> json) => _$AttendanceResultFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceResultToJson(this);

}