
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpDone extends StatelessWidget {
  const SignUpDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Image.asset("assets/images/congratulations.png"),
          Text("Congratulations !",style: TextStyle(
            fontFamily: GoogleFonts.lato().fontFamily,
            fontSize: 30.0,
            fontWeight: FontWeight.w200
          ),),
          Text("You have created account Successfully",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: GoogleFonts.robotoSerif().fontFamily,
               fontSize: 25.0,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 40,),
          ElevatedButton(onPressed: (){},
          child: Text("Log in Now",style: TextStyle(
            color: Colors.white
          ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF145374),
          )
          
          
          )

        ],

      ),

    );
  }
}