import 'dart:convert';
import 'package:cliqueledger/models/member.dart';
import 'package:http/http.dart' as http;

class MemberList {
  List<Member> members = [];
  List<Member> memberDemo = [
      Member(name: "Ant"),
      Member(name: "Seo Ri"),
      Member(name: "Ko Mun Young"),
      Member(name: "Seo Yeo Ji"),
      Member(name: "Tian Tian"),
    // // Add more transactions here
  ];

  Future<void> fetchMembersByEmail(String email) async {
    final uriGet = Uri.parse("https://yourapi.com/users?email=$email"); // Update the API endpoint
    try {
      final response = await http.get(uriGet);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        members = jsonList.map((jsonItem) => Member.fromJson(jsonItem)).toList();
        print("Data fetched successfully: ${response.body}");
      } else {
        // Handle error response
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions
      print("Exception occurred: $e");
    }
    members = memberDemo;
  }
}
