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

// import 'package:cliqueledger/service/authservice.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class Signup extends StatelessWidget {
//   const Signup({super.key});

//   @override
//   Widget build(BuildContext context) {
//     ValueNotifier<bool> changedButton = ValueNotifier(false);

//     return ChangeNotifierProvider(
//       create: (_) => Authservice.instance.loginInfo,
//       child: Consumer<LoginInfo>(
//         builder: (context, loginInfo, child) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text("Signup"),
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Image.asset(
//                     "assets/images/hello.png",
//                     fit: BoxFit.cover,
//                   ),
//                   SizedBox(
//                     height: 30.0,
//                   ),
//                   Text(
//                     "Hey There! New here?",
//                     style: TextStyle(
//                       fontFamily: GoogleFonts.pacifico().fontFamily,
//                       fontSize: 30.0,
//                       color: Color(0xFF145374),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           decoration: InputDecoration(
//                             hintText: "Enter your First Name",
//                             labelText: "First Name",
//                           ),
//                         ),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             hintText: "Enter your Last Name",
//                             labelText: "Last Name",
//                           ),
//                         ),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             hintText: "Enter your email",
//                             labelText: "Email",
//                           ),
//                         ),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             hintText: "Enter your Phone Number",
//                             labelText: "Phone",
//                           ),
//                         ),
//                         TextFormField(
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             hintText: "Create a Password",
//                             labelText: "Password",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       changedButton.value = true;
//                     },
//                     child: ValueListenableBuilder<bool>(
//                       valueListenable: changedButton,
//                       builder: (context, value, child) {
//                         return AnimatedContainer(
//                           duration: Duration(milliseconds: 300),
//                           width: value ? 50 : 150,
//                           height: 50,
//                           alignment: Alignment.center,
//                           child: value
//                               ? Icon(
//                                   Icons.done,
//                                   color: Colors.white,
//                                 )
//                               : Text(
//                                   "Sign Up",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18.0,
//                                   ),
//                                 ),
//                           decoration: BoxDecoration(
//                             color: Color(0xFF145374),
//                             borderRadius: BorderRadius.circular(value ? 50 : 6),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await Authservice.instance.login();
//                       if (Authservice.instance.loginInfo.isLoggedIn) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Login successful')),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Login failed')),
//                         );
//                       }
//                     },
//                     child: Text("Register | Login"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


