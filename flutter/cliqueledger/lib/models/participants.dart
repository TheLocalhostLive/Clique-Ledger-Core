import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

class Participant{
  @JsonKey(name: "name")
  final String name;
  
  @JsonKey(name:"member_id")
  String memberId;
  @JsonKey(name:"part_amount")
  int partAmount ;
  Participant({
    required this.name,
    required this.memberId,
    required this.partAmount
  });

  factory Participant.fromJson(Map<String,dynamic>json){
    return Participant(
     name:json['name'],
     memberId: json['member_id'], 
     partAmount: json['part_amount']
     );
   }
   Map<String,dynamic> toJson(){
    return {
      'name':name,
      'member_id':memberId,
      'part_amount':partAmount
    };
   }

}

