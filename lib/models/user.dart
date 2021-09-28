import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum Role {
  Guest,
  Admin
}

@JsonSerializable()
class User {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final Role role;

  User({required this.firstName, required this.lastName, required this.username, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}