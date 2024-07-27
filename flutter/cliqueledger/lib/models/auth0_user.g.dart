// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth0_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth0User _$Auth0UserFromJson(Map<String, dynamic> json) => Auth0User(
      sub: json['sub'] as String,
      nickname: json['nickname'] as String,
      name: json['name'] as String,
      picture: json['picture'] as String,
      updatedAt: json['updated_at'] as String,
      email: json['email'] as String,
      emailVerified: json['email_verified'] as bool,
    );

Map<String, dynamic> _$Auth0UserToJson(Auth0User instance) => <String, dynamic>{
      'sub': instance.sub,
      'nickname': instance.nickname,
      'name': instance.name,
      'picture': instance.picture,
      'updated_at': instance.updatedAt,
      'email_verified': instance.emailVerified,
      'email': instance.email,
    };
