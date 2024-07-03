
import 'package:cliqueledger/themes/appBarTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defualtPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black
      ),
      decoration: BoxDecoration(
        color: Color(0xFFa2b4bd),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent)
    ));
    return Scaffold(
      appBar: GradientAppBar(title: "OTP Verification"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Column(
            children: [
              Text("Otp is sent to to your whatsapp and your email",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              Pinput(
                length: 6,
                defaultPinTheme: defualtPinTheme,
                focusedPinTheme: defualtPinTheme.copyWith(
                  decoration: defualtPinTheme.decoration!.copyWith(
                    border: Border.all(color:const  Color(0xFF145374))
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
