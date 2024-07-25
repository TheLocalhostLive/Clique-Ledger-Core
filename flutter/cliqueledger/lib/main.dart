import 'package:cliqueledger/pages/dashboard.dart';
import 'package:cliqueledger/service/authservice.dart';
import 'package:cliqueledger/utility/routers.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  
  try {
    bool isInitialized = await Authservice.instance.init(); // Await Authservice initialization
    if (!isInitialized) {
      // Handle the case where initialization fails (optional)
      print("No refresh token");
    }
  } catch (e) {
    // Handle any exceptions thrown during initialization
    print("Error during initialization: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clique Ledger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard()
    );
  }
}