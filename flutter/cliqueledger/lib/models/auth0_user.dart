import 'package:json_annotation/json_annotation.dart';
part 'auth0_user.g.dart';

@JsonSerializable()
class Auth0User {
  Auth0User(
      {required this.sub,
      required this.nickname,
      required this.name,
      required this.picture,
      required this.updatedAt,
      required this.email,
      required this.emailVerified});

  String get id => sub;

  final String sub;
  final String nickname;
  final String name;
  final String picture;

  @JsonKey(name: "updated_at")
  final String updatedAt;
  @JsonKey(name: "email_verified")
  final bool emailVerified;

  final String email;

  factory Auth0User.fromJson(Map<String, dynamic> json) =>
      _$Auth0UserFromJson(json);

  Map<String, dynamic> toJson() => _$Auth0UserToJson(this);

  @override
  String toString() {
    return {
      'sub': sub,
      'nickname': nickname,
      'name': name,
      'picture': picture,
      'updatedAt': updatedAt,
      'emailVerified': emailVerified,
      'email': email,
    }.toString();
  }
}
