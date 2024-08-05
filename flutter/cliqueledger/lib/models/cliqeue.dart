import 'package:cliqueledger/models/admin.dart';
import 'package:cliqueledger/models/member.dart';
import 'package:cliqueledger/models/transaction.dart';
import 'package:cliqueledger/models/user.dart';

class Clique{
  final String id;
  final String name;
  final List<Member> admins;
  final List<Member> members;
  final bool isActive;
  final Transaction latestTransaction;

  Clique({
    required this.id,
    required this.name,
    required this.admins,
    required this.members,
    required this.isActive,
    required this.latestTransaction,

  });
    factory Clique.fromJson(Map<String, dynamic> json) {
    return Clique(
      id: json['id'] as String,
      name: json['name'] as String,
      admins: (json['admins'] as List<dynamic>)
          .map((item) => Member.fromJson(item as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>)
          .map((item) => Member.fromJson(item as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool,
      latestTransaction: Transaction.fromJson(json['latestTransaction'] as Map<String, dynamic>),
    );
  }
}

//     factory Clique.fromJson(Map<String, dynamic> json) {
//     return Clique(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       admins: (json['admins'] as List<dynamic>)
//           .map((item) => User.fromJson(item as Map<String, dynamic>))
//           .toList(),
//       members: (json['members'] as List<dynamic>)
//           .map((item) => User.fromJson(item as Map<String, dynamic>))
//           .toList(),
//       fund: json['fund'] != null ? json['fund'] as int : null,
//       spend: json['spend'] != null ? json['spend'] as int : null,
//       send: json['send'] as int,
//       isActive: json['isActive'] as bool,
//       latestTransaction: Transaction.fromJson(json['latestTransaction'] as Map<String, dynamic>),
//     );
//   }
// }

  // factory Clique.fromJson(Map<String,dynamic> json){
  //   return Clique(
  //     cliqeueName: json['ledgerName'],
  //     cliqueId: json['cliqueId']

  //     );
  // }
  // Map<String , dynamic> toJson()=>{
  //   "cliqeueName":cliqeueName,
  //   "cliqueId":cliqueId
  // };
