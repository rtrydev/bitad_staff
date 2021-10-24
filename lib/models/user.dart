import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum Role {
  Guest,
  Admin,
  Super
}

@JsonSerializable()
class User {
  final String username;
  final String email;
  final Role role;
  final String? firstName;
  final String? lastName;

  User({required this.username, required this.email, required this.role, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}