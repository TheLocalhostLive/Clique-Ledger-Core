class Clique{
  final String  cliqeueName;
  final String cliqueId;

  Clique({
    required this.cliqeueName,
    required this.cliqueId
  });

  factory Clique.fromJson(Map<String,dynamic> json){
    return Clique(
      cliqeueName: json['ledgerName'],
      cliqueId: json['cliqueId']

      );
  }
}