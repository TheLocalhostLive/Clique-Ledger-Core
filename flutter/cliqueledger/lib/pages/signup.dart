import 'package:cliqueledger/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> changedButton = ValueNotifier(false);

    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/hello.png",
              fit: BoxFit.cover,
            ),  
            const SizedBox(
              height: 30.0,
            ),
            Text(
              "Hey There! New here?",
              style: TextStyle(
                fontFamily: GoogleFonts.pacifico().fontFamily,
                fontSize: 30.0,
                color: const Color(0xFF145374),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const SizedBox(
              height: 20.0,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              // onPressed: () async {
              //   //await Authservice.instance.login();
              //   if (Authservice.instance.loginInfo.isLoggedIn) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('Login successful')),
              //     );
              //   } else {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('Login failed')),
              //     );
              //   }
              // },
              onPressed: () async {
                await Authservice.instance.login();
                if (Authservice.instance.loginInfo.isLoggedIn) {
                  // Navigate to the dashboard or update the UI accordingly
                  Navigator.pushNamed(context, '/api/auth/dashboard');
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login failed')),
                  );
                }
              },
              child: const Text("Register | Login"),
            ),
          ],
        ),
      ),
    );
  }
}


