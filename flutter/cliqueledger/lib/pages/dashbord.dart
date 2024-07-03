
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class Dashbord extends StatelessWidget {
  const Dashbord({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: GradientAppBar(title:"Clique Ledger"),
        body: const Column(children: [
          TabBar(
            tabs:[
              Tab(text:"Active Ledger"),
              Tab(text:"Finished Ledger")
            ]
         ),Expanded(
           child: TabBarView(
            children: [
              Center(child: Text("Active Ledger Content")),
              Center(child: Text("Finished Ledger Content")),
            ],
                   ),
         ),
        ],),
      ),
    );
  }
}
