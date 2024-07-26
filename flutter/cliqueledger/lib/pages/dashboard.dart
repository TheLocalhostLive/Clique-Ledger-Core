import 'package:cliqueledger/api_helpers/activeLedgerContent.dart';
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
    void _createClique(BuildContext context) {
    // Navigate to create page or show a dialog
    // For demonstration, we'll show a simple dialog
 showDialog(
  context: context,
  builder: (BuildContext context) {
    bool withFunds = false;
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('Create Clique'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(hintText: "Enter Clique Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Clique Name cannot be empty";
                    }
                    return null;
                  },
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: withFunds,
                      onChanged: (bool? value) {
                        setState(() {
                          withFunds = value ?? false;
                        });
                      },
                    ),
                    const Text("With funds"),
                  ],
                ),
                if (withFunds)
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(hintText: "Enter Amount"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Amount cannot be empty";
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Handle the create action
                  String amount = amountController.text;
                  // Use the amount if withFunds is true
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  },
); 
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const GradientAppBar(title:"Clique Ledger"),
        body: const Column(children: [
          TabBar(
            tabs:[
              Tab(text:"Active Ledger"),
              Tab(text:"Finished Ledger")
            ]
         ),Expanded(
          child: TabBarView(
            children: [
              ActiveLedgerContent(),
              Center(child: Text("Finished Ledger Content")),
            ],
          ),
         ),
        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createClique(context),
            tooltip: 'Create Clique',
           child: const Icon(Icons.add),
          ),
      ),
    );
  }
}
