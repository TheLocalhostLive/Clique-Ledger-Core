import 'package:cliqueledger/models/cliqeue.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActiveLedgerContentList{

  List<Clique> ledgerList = [];
  // List<Clique> ledgerListDemo = [
  //  Clique(cliqeueName: "Purulia"),
  //  Clique(cliqeueName: "Manali"),
  //  Clique(cliqeueName: "Digha"),
  //  Clique(cliqeueName: "Japan"),
  //  Clique(cliqeueName: "Usa"),
  //  Clique(cliqeueName: "UK"),
  //  Clique(cliqeueName: "Estonia"),
  //  Clique(cliqeueName: "Korea"),
  //  Clique(cliqeueName: "Thailand"),
  //  Clique(cliqeueName: "China"),
  //  Clique(cliqeueName: "Taiwan"),
  //  Clique(cliqeueName: "Iran"),
  //  Clique(cliqeueName: "Russia"),
  // ];

  Future<void> fetchData() async{
    final uriGet = Uri.parse("http://example.com/api/transactions");
    try {
      final response = await http.get(uriGet);
      if (response.statusCode == 200) {
         final List<dynamic> jsonList = json.decode(response.body);
         ledgerList  = jsonList.map((jsonItem) => Clique .fromJson(jsonItem)).toList();
        print("Data fetched successfully: ${response.body}");
      } else {
        // Handle error response
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions
      print("Exception occurred: $e");
    }
    //ledgerList = ledgerListDemo;
  }

}


