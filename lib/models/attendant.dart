import 'package:json_annotation/json_annotation.dart';

part 'attendant.g.dart';

@JsonSerializable()
class Attendant {
  final String? firstName;
  final String? lastName;
  final String? workshopAttendanceCode;

  Attendant({ this.firstName,  this.lastName, this.workshopAttendanceCode});

  factory Attendant.fromJson(Map<String, dynamic> json) => _$AttendantFromJson(json);
  Map<String, dynamic> toJson() => _$AttendantToJson(this);

}