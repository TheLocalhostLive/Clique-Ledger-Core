import 'package:cliqueledger/utility/routers_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        Image.asset("assets/images/take_love.png"),
        const Text(
          "Welcome to Cliqeue Ledger",
          style: TextStyle(fontSize: 25.0),
        ),
        ElevatedButton(
          child: const Text("Get Started"),
          onPressed: () {
            GoRouter.of(context).pushNamed(RoutersConstants.signUpPageRoute);
          },
        )
      ],
    ));
  }
}
