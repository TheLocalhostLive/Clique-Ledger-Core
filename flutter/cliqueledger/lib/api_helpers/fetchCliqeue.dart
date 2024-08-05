import 'package:cliqueledger/models/cliqeue.dart';
import 'package:cliqueledger/utility/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CliqueList{

  List<Clique> cliqueList = [];
  List<Clique> activeCliqueList=[];
  List<Clique> finishedCliqueList=[];
  Future<void> fetchData() async{
   final uriGet = Uri.parse('${BASE_URL}/cliques');
    try {
      final response = await http.get(uriGet);
      if (response.statusCode == 200) {
         final List<dynamic> jsonList = json.decode(response.body);
         cliqueList  = jsonList.map((jsonItem) => Clique .fromJson(jsonItem)).toList();
         for(Clique cl in cliqueList){
            if(cl.isActive){
              activeCliqueList.add(cl);
            }else{
              finishedCliqueList.add(cl);
            }
         }
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


