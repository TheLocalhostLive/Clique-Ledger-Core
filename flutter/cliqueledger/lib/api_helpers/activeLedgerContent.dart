import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActiveLedgerContent extends StatelessWidget {
  const ActiveLedgerContent({super.key});

  Future<List<dynamic>> fetchActiveLedgers() async {
    final response = await http.get(Uri.parse('https://your-api-url.com/active-ledgers'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load active ledgers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchActiveLedgers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Active Ledgers'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ledger = snapshot.data![index];
              return ListTile(
                title: Text(ledger['name']),
                subtitle: Text('ID: ${ledger['id']}'),
              );
            },
          );
        }
      },
    );
  }
}
