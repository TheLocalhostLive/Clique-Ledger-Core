import 'package:cliqueledger/service/authservice.dart';
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:cliqueledger/utility/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class Dashbord extends StatelessWidget {
  const Dashbord({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: GradientAppBar(title: "Clique Ledger"),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "Active Ledger"),
                Tab(text: "Finished Ledger"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: LogoutButton(),
                  ),
                  const Center(
                    child: Text("Finished Ledger Content"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Logout"),
      onPressed: () async {
        Authservice.instance.loginInfo.isLoggedIn = false;
        FlutterSecureStorage secureStorage = const FlutterSecureStorage();
        await secureStorage.delete(key: REFRESH_TOKEN_KEY);
        print("set to false");
        context.go("/");
      },
    );
  }
}
