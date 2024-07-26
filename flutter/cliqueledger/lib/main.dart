import 'package:cliqueledger/pages/ledgerPage.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clique Ledger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Ledgerpage()
    );
  }
}