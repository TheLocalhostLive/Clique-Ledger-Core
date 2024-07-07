// InkWell(
//               onTap: () {
//                 changedButton.value = true;
//               },
//               child: ValueListenableBuilder<bool>(
//                 valueListenable: changedButton,
//                 builder: (context, value, child) {
//                   return AnimatedContainer(
//                     duration: Duration(milliseconds: 300),
//                     width: value ? 50 : 150,
//                     height: 50,
//                     alignment: Alignment.center,
//                     child: value
//                         ? Icon(
//                             Icons.done,
//                             color: Colors.white,
//                           )
//                         : Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18.0,
//                             ),
//                           ),
//                     decoration: BoxDecoration(
//                       color: Color(0xFF145374),
//                       borderRadius: BorderRadius.circular(value ? 50 : 6),
//                     ),
//                   );
//                 },
//               ),
//             ),