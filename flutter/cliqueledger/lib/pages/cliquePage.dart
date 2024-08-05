import 'package:cliqueledger/api_helpers/fetchTransactions.dart';
import 'package:cliqueledger/models/cliqeue.dart';
import 'package:cliqueledger/models/participants.dart';
import 'package:cliqueledger/providers/cliqueProvider.dart';
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:cliqueledger/utility/routers_constant.dart';
import 'package:flutter/material.dart';
import 'package:cliqueledger/models/transaction.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Cliquepage extends StatefulWidget {

  const Cliquepage({super.key});

  @override
  State<Cliquepage> createState() => _CliquepageState();
}

class _CliquepageState extends State<Cliquepage> {
  final TransactionList transactionList = TransactionList();
  bool isLoading = true;
  @override
  void initState(){
    super.initState();
    fetchTransactions();
  }
 Future<void> fetchTransactions() async {
    // final clique = context.read<CliqueProvider>().currentClique;
    // if (clique != null) {
    //   await transactionList.fetchData(clique.id); // Pass the cliqueId here
    //   setState(() {
    //     isLoading = false;
    //   });
    // } else {
    //   // Handle the case where clique is null, if necessary
    // }
    await transactionList.fetchData("123");
    isLoading = false;
  }

  void _createTransaction(BuildContext context) {
     showDialog(
  context: context,
  builder: (BuildContext context) {
    bool withFunds = false;
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('Create Transaction'),
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
      length: 3,
      child: Scaffold(
        appBar:  AppBar(
          title: Text("Clique Ledger",style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: ()=>{context.go(RoutersConstants.CLIQUE_SETTINGS_ROUTE)},
              icon: Icon(Icons.settings,
              color: Colors.white,),
            )
          ],
          flexibleSpace: Container(
          
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5588A3), // Note the use of 0xFF prefix for hex colors
                Color(0xFF145374),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
        body: Column(
          children: [
            TabBar(tabs: [
              Tab(text: "Transaction"),
              Tab(text: "Media"),
              Tab(text: "Report"),
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : transactionList.transactions.isEmpty
                          ? const Center(child: Text("No Transaction to show"))
                          : TransactionsTab(transactions: transactionList.transactions),
                  Center(child: Text('Media')),
                  Center(child: Text('Report')),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createTransaction(context),
          tooltip: 'Create Transaction',
          backgroundColor: Color.fromARGB(255, 27, 62, 75),
          child: const Icon(Icons.add,color: Color.fromARGB(255, 255, 255, 255),),
        ),
      ),
    );
  }
}

class TransactionsTab extends StatelessWidget {
  final List<Transaction> transactions;
  
  const TransactionsTab({required this.transactions});

void _checkTransaction(BuildContext context, Transaction t) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text(
              'Transaction Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (t.type == "send") ...[
                    Text(
                      '${t.sender.name} : \u{20B9}${t.sendAmount?.toStringAsFixed(2) ?? 'N/A'} paid to ${t.participants[0].name}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    Text(
                      '${t.sender.name} Paid Total: \u{20B9}${t.spendAmount?.toStringAsFixed(2) ?? 'N/A'} To -',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...t.participants.map(
                      (p) => Text(
                        '${p.name} - \u{20B9}${p.partAmount}',
                        style:  TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ).toList(),
                  ],
                  SizedBox(height: 20),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${t.description}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => {},
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00334E),
                      minimumSize: Size(double.infinity, 36), // Full-width button
                      padding: const EdgeInsets.symmetric(vertical: 12), // Add vertical padding
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close',style: TextStyle(color: Color.fromARGB(255, 1, 47, 63)),),
                onPressed: () {
                  Navigator.of(context).pop();
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
    return ListView(
      children: transactions.map((tx) {
        return Center(
          child: Container(
            // margin:
            //     const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
            margin: const EdgeInsets.fromLTRB(60, 10, 5, 10),
            width: MediaQuery.of(context).size.width * 0.7,
            height: 100, // Set desired height
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                focusColor: Colors.amberAccent,
                onTap: () => _checkTransaction(context, tx),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 235, 165,
                              43), // Note the use of 0xFF prefix for hex colors
                          Color.fromARGB(255, 241, 205, 58),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20)),

                  padding: const EdgeInsets.all(
                      8.0), // Add padding for better appearance
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tx.sender} - \u{20B9}${tx.spendAmount != null ? tx.spendAmount!.toStringAsFixed(2):tx.sendAmount!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Date: ${tx.date.toLocal()}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        tx.description,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
