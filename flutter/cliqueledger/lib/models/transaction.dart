import 'package:cliqueledger/models/member.dart';
import 'package:cliqueledger/models/participants.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Transaction {
  @JsonKey(name: "transaction_id")
  final String id;
  @JsonKey(name: "clique_id")
  final String cliqueId;
  @JsonKey(name: "transaction_type")
  final String type;
  @JsonKey(name:"sender_id")
  final Member sender;
  final List<Participant> participants;
  @JsonKey(name: "spend_amount")
  final double? spendAmount ;
  @JsonKey(name: "send_amount")
  final double? sendAmount;
  @JsonKey(name:" done_at")
  final DateTime date;
  final String description;

  Transaction({
    required this.id,
    required this.cliqueId,
    required this.type,
    required this.sender,
    required this.participants,
    
    this.spendAmount,
    this.sendAmount,
    required this.date,
    required this.description,
  });

   factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['transaction_id'] as String,
      cliqueId: json['clique_id'] as String,
      type: json['transaction_type'] as String,
      sender: Member.fromJson(json['sender_id']),
      participants: (json['participants'] as List)
          .map((e) => Participant.fromJson(e))
          .toList(),
      spendAmount: (json['spend_amount'] as num?)?.toDouble(),
      sendAmount: (json['send_amount'] as num?)?.toDouble(),
      date: DateTime.parse(json['done_at'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': id,
      'clique_id': cliqueId,
      'transaction_type': type,
      'sender_id': sender.toJson(),
      'participants': participants.map((e) => e.toJson()).toList(),
      'spend_amount': spendAmount,
      'send_amount': sendAmount,
      'done_at': date.toIso8601String(),
      'description': description,
    };
  }
  
}


