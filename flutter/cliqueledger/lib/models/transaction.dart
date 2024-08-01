class Transaction {
  final String id;
  final String sender;
  final String receiver;
  final bool spend;
  final bool send ;
  final double amount;
  final DateTime date;
  final String description;

  Transaction({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.spend,
    required this.send,
    required this.amount,
    required this.date,
    required this.description,
  });
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      spend: json['spend'],
      send: json['send'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}

