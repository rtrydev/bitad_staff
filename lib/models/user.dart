import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum Role {
  Guest,
  Admin,
  Super
}

@JsonSerializable()
class User {
  final String email;
  final Role role;
  final String? firstName;
  final String? lastName;
  final String? rewardCode;

  User({ required this.email, required this.role, this.firstName, this.lastName, this.rewardCode});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}