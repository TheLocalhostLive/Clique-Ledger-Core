import 'package:flutter/material.dart';
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

class TransactionsScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView(
        children: transactions.map((tx) {
          return Card(
            child: ExpansionTile(
              title: Text('${tx.recipient} - \$${tx.amount.toStringAsFixed(2)}'),
              children: <Widget>[
                ListTile(
                  title: Text('Date: ${tx.date.toLocal().toString()}'),
                  subtitle: Text(tx.description),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
