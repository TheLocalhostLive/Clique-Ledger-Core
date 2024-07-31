import 'dart:convert';

import 'package:cliqueledger/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionList {

    // List<Transaction> transactions=[];
    List<Transaction> transactions = [];
    List<Transaction> transactionsDemo = [
    Transaction(
      id: 't1',
      sender: 'Alice',
      receiver: 'Bob',
      spend: false,
      send: true,
      amount: 1000,
      date: DateTime.now(),
      description: "Alice Paid To Bob",
    ),
    Transaction(
      id: 't2',
      sender: 'Bob',
      receiver: 'Dan',
      spend: false,
      send: true,
      amount: 2000,
      date: DateTime.now(),
      description: "Bob Paid To Dan",
    )
    // // Add more transactions here
  ];

  Future<void> fetchData() async {
    final uriGet = Uri.parse("http://example.com/api/transactions");
    try {
      final response = await http.get(uriGet);
      if (response.statusCode == 200) {
         final List<dynamic> jsonList = json.decode(response.body);
         transactions = jsonList.map((jsonItem) => Transaction.fromJson(jsonItem)).toList();
        print("Data fetched successfully: ${response.body}");
      } else {
        // Handle error response
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions
      print("Exception occurred: $e");
    }
    transactions = transactionsDemo;
  }
  
}
