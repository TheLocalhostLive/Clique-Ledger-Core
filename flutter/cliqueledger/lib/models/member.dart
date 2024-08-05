import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

class Member{
  final String name;
  @JsonKey(name: "member_id")
  final String memberId;
  @JsonKey(name: "is_admin")
  final bool isAdmin;

  Member({
    required this.name,
    required this.memberId,
    required this.isAdmin
    
  });
 
  

  factory Member.fromJson(Map<String,dynamic> json){
    return Member(
      name: json["name"],
      memberId: json["member_id"],
      isAdmin: json['is_admin']
      );
  }
  Map<String,dynamic> toJson(){
    return {
      'name':name,
      'member_id':memberId,
      'is_admin':isAdmin
    };

  }
}