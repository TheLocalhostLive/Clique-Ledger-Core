
import 'dart:convert';
import 'package:cliqueledger/models/cliquePostSchema.dart';
import 'package:http/http.dart' as http;
class CreateCliquePost{
   final uriPost = Uri.parse("http://example.com/api/transactions");

   Future<void> postData(CliquePostSchema object) async{
       var _payload = json.encode(object);
       final response = await http.post(uriPost , body: _payload);
   }

}