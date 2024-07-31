import 'package:cliqueledger/api_helpers/fetchTransactions.dart';
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/material.dart';
import 'package:cliqueledger/models/transaction.dart';

class Ledgerpage extends StatefulWidget {
  const Ledgerpage({super.key});

  @override
  State<Ledgerpage> createState() => _LedgerpageState();
}

class _LedgerpageState extends State<Ledgerpage> {
  final TransactionList transactionList = TransactionList();
  bool isLoading = true;
  @override
  void initState(){
    super.initState();
    fetchTransactions();
  }
  Future<void> fetchTransactions() async {
    await transactionList.fetchData();
    setState(() {
      isLoading = false;
    });
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
      length: 3,
      child: Scaffold(
        appBar: const GradientAppBar(title: "Clique Ledger"),
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
          child: const Icon(Icons.add),
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
              title: Text('Transaction Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Add your transaction details widgets here
                  Text(
                    '${t.sender} - \$${t.amount.toStringAsFixed(2)} paid to ${t.receiver}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      "Verify",
                      style: TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00334E), // Set button color to #00334E
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
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
                        '${tx.sender} - \$${tx.amount.toStringAsFixed(2)}',
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
