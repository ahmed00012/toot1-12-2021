// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:toot/constants.dart';
//
// class SingleChoicePayment extends StatefulWidget {
//   final String title;
//   final int index;
//   final Function function;
//   final String image;
//   final List<bool> choicesList;
//   final String method;
//
//   final bool? isVisa;
//
//   SingleChoicePayment(
//       {required this.title,
//       required this.index,
//       required this.function,
//       required this.choicesList,
//       required this.image,
//       required this.isVisa,
//       required this.method});
//
//   @override
//   _SingleChoicePaymentState createState() => _SingleChoicePaymentState();
// }
//
// class _SingleChoicePaymentState extends State<SingleChoicePayment> {
//   bool selected = false;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           selected = !selected;
//           widget.function(selected, widget.index, widget.method);
//         });
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//             border: Border.all(
//                 color: !selected ? Colors.black : Color(Constants.mainColor),
//                 width: 1),
//             borderRadius: BorderRadius.circular(8)),
//         child: Row(
//           children: [
//             Container(
//               height: 0.1.sw,
//               width: 0.1.sw,
//               child: Image.network(
//                 widget.image,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Text(
//               widget.title,
//               style: TextStyle(
//                   color: selected
//                       ? Color(Constants.mainColor)
//                       : Colors.grey.shade600,
//                   fontSize: 18.sp,
//                   decoration: widget.isVisa!
//                       ? TextDecoration.underline
//                       : TextDecoration.none),
//             ),
//             Spacer(),
//             Center(
//                 child: Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: selected
//                   ? Icon(
//                       FontAwesomeIcons.solidCheckCircle,
//                       size: 25.0,
//                       color: Color(Constants.mainColor),
//                     )
//                   : Icon(
//                       FontAwesomeIcons.solidCircle,
//                       size: 25.0,
//                       color: Colors.grey.shade300,
//                     ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }
