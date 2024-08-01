import 'package:cliqueledger/models/ledger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActiveLedgerContentList{

  List<Ledger> ledgerList = [];
  List<Ledger> ledgerListDemo = [
   Ledger(ledgerName: "Purulia"),
   Ledger(ledgerName: "Manali"),
   Ledger(ledgerName: "Digha"),
   Ledger(ledgerName: "Japan"),
   Ledger(ledgerName: "Usa"),
   Ledger(ledgerName: "UK"),
   Ledger(ledgerName: "Estonia"),
   Ledger(ledgerName: "Korea"),
   Ledger(ledgerName: "Thailand"),
   Ledger(ledgerName: "China"),
   Ledger(ledgerName: "Taiwan"),
   Ledger(ledgerName: "Iran"),
   Ledger(ledgerName: "Russia"),
  ];

  Future<void> fetchData() async{
    final uriGet = Uri.parse("http://example.com/api/transactions");
    try {
      final response = await http.get(uriGet);
      if (response.statusCode == 200) {
         final List<dynamic> jsonList = json.decode(response.body);
         ledgerList  = jsonList.map((jsonItem) => Ledger .fromJson(jsonItem)).toList();
        print("Data fetched successfully: ${response.body}");
      } else {
        // Handle error response
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions
      print("Exception occurred: $e");
    }
    ledgerList = ledgerListDemo;
  }

}


