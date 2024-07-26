
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/material.dart';
class Dashbord extends StatelessWidget {
  const Dashbord({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: GradientAppBar(title:"Clique Ledger"),
        body: Column(children: [
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
