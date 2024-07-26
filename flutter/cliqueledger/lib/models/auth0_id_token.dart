// import 'package:json_annotation/json_annotation.dart';

// part 'auth0_id_token.g.dart';

// @JsonSerializable()
// class Auth0IdToken {
//   Auth0IdToken({
//     required this.nickname,
//     required this.name,
//     required this.email,
//     required this.picture,
//     required this.updateAt,
//     required this.iss,
//     required this.sub,
//     required this.aud,
//     required this.iat,
//     required this.exp,
//     this.authTime,
//   });

//   final String nickname;
//   final String name;
//   final String email;
//   final String picture;

//   @JsonKey(name: 'updated_at')
//   final String updateAt;

//   final String iss;
//   String get userId => sub;
//   final String sub;
  
//   final String aud;
//   final String iat;
//   final String exp;
//   final String? authTime;

//   factory Auth0IdToken.fromJson(Map<String, dynamic> json) => _$Auth0IdTokenFromJson(json);
//   Map<String, dynamic> toJson() => _$Auth0IdTokenToJson(this);
// }
