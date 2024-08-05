import 'dart:convert';

import 'package:cliqueledger/models/member.dart';
import 'package:cliqueledger/models/participants.dart';
import 'package:cliqueledger/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionList {
   List<Transaction> transactions = [];

  late Member dummySender1;
  late Member dummySender2;

  late List<Participant> dummyParticipants1;
  late List<Participant> dummyParticipants2;

  late List<Transaction> dummyTransactions;

  TransactionList() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    dummySender1 = Member(
      name: 'John Doe',
      memberId: 'member_001',
      isAdmin: true,
    );

    dummySender2 = Member(
      name: 'Jane Smith',
      memberId: 'member_002',
      isAdmin: false,
    );

    dummyParticipants1 = [
      Participant(
        name: 'Alice Smith',
        memberId: 'participant_001',
        partAmount: 500,
      ),
      Participant(
        name: 'Bob Johnson',
        memberId: 'participant_002',
        partAmount: 300,
      ),
    ];

    dummyParticipants2 = [
      Participant(
        name: 'Charlie Brown',
        memberId: 'participant_003',
        partAmount: 700,
      ),
      Participant(
        name: 'Diana Prince',
        memberId: 'participant_004',
        partAmount: 450,
      ),
      Participant(
        name: 'Eve Adams',
        memberId: 'participant_005',
        partAmount: 350,
      ),
    ];

    dummyTransactions = [
      Transaction(
        id: 'txn_001',
        cliqueId: 'clique_001',
        type: 'spend',
        sender: dummySender1,
        participants: dummyParticipants1,
        spendAmount: 800.0,
        sendAmount: null,
        date: DateTime.now().subtract(Duration(days: 1)),
        description: 'Lunch with friends',
      ),
      Transaction(
        id: 'txn_002',
        cliqueId: 'clique_002',
        type: 'send',
        sender: dummySender2,
        participants: [dummyParticipants2[0]],
        spendAmount: null,
        sendAmount: 700.0,
        date: DateTime.now().subtract(Duration(days: 2)),
        description: 'Money sent for tickets',
      ),
      Transaction(
        id: 'txn_003',
        cliqueId: 'clique_003',
        type: 'spend',
        sender: dummySender1,
        participants: dummyParticipants2,
        spendAmount: 1500.0,
        sendAmount: null,
        date: DateTime.now().subtract(Duration(days: 3)),
        description: 'Group outing expenses',
      ),
    ];
  }
  Future<void> fetchData(String cliqeuId) async {
    // final uriGet = Uri.parse("http://example.com/api/transactions");
    // try {
    //   final response = await http.get(uriGet);
    //   if (response.statusCode == 200) {
    //      final List<dynamic> jsonList = json.decode(response.body);
    //      transactions = jsonList.map((jsonItem) => Transaction.fromJson(jsonItem)).toList();
    //     print("Data fetched successfully: ${response.body}");
    //   } else {
    //     // Handle error response
    //     print("Error fetching data: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   // Handle exceptions
    //   print("Exception occurred: $e");
    // }
    _initializeDummyData();
    transactions = dummyTransactions;
  }
  
}
