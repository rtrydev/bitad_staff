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

  User({required this.username, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}