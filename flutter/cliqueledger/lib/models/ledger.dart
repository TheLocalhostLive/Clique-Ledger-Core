class Ledger{
  final String  ledgerName;

  Ledger({
    required this.ledgerName
  });

  factory Ledger.fromJson(Map<String,dynamic> json){
    return Ledger(ledgerName: json['ledgerName']);
  }
}