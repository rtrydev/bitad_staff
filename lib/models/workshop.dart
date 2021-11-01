import 'package:bitad_staff/models/speaker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workshop.g.dart';

@JsonSerializable()
class Workshop {
  final String title;
  final String code;
  final Speaker speaker;

  Workshop({required this.title, required this.code, required this.speaker});

  factory Workshop.fromJson(Map<String, dynamic> json) => _$WorkshopFromJson(json);
  Map<String, dynamic> toJson() => _$WorkshopToJson(this);

}