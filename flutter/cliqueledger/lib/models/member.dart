import 'package:flutter/foundation.dart';

class Member{
  final String name;
  Member({
    required this.name,
  });

  factory Member.fromJson(Map<String,dynamic> json){
    return Member(name: json["name"]);
  }
}