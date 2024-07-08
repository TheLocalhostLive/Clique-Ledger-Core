import 'package:cliqueledger/service/authservice.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
            SizedBox(
              height: 30.0,
            ),
            Text(
              "Hey There! New here?",
              style: TextStyle(
                fontFamily: GoogleFonts.pacifico().fontFamily,
                fontSize: 30.0,
                color: Color(0xFF145374),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
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
                    SnackBar(content: Text('Login failed')),
                  );
                }
              },
              child: Text("Register | Login"),
            ),
          ],
        ),
      ),
    );
  }
}


