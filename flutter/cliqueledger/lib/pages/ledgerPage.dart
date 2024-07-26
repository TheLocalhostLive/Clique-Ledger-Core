import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/material.dart';

class Ledgerpage extends StatefulWidget {
  const Ledgerpage({super.key});

  @override
  State<Ledgerpage> createState() => _LedgerpageState();
}

class _LedgerpageState extends State<Ledgerpage> {
  final List<Transaction> transactions = [
    Transaction(
      id: 't1',
      recipient: 'Alice',
      amount: 50.0,
      date: DateTime.now(),
      description: 'Payment for dinner',
    ),
    Transaction(
      id: 't2',
      recipient: 'Bob',
      amount: 20.0,
      date: DateTime.now(),
      description: 'Coffee meeting',
    ),
    // Add more transactions here
  ];

  void _createTransaction(BuildContext context) {
    // Implement your transaction creation logic here
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
                  transactions.isEmpty
                      ? Center(child: Text("No Transaction to show"))
                      : TransactionsTab(transactions: transactions),
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
                    '${t.recipient} - \$${t.amount.toStringAsFixed(2)} paid to ',
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
                        '${tx.recipient} - \$${tx.amount.toStringAsFixed(2)}',
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

class Transaction {
  final String id;
  final String recipient;
  final double amount;
  final DateTime date;
  final String description;

  Transaction({
    required this.id,
    required this.recipient,
    required this.amount,
    required this.date,
    required this.description,
  });
}
