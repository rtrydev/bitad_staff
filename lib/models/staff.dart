import 'package:json_annotation/json_annotation.dart';

part 'staff.g.dart';

@JsonSerializable()
class Staff {
  final String name;
  final String picture;
  final String description;
  final String? degree;
  final String? contact;

  Staff({required this.name, required this.picture, required this.description, this.degree, this.contact});

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
  Map<String, dynamic> toJson() => _$StaffToJson(this);

}