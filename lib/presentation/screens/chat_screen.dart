// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:toot/constants.dart';
// import 'package:toot/presentation/widgets/customised_appbar.dart';
//
// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: BuildAppBar(
//           title: 'محادثة مع فريق العمل',
//           isBack: false,
//         ),
//         bottomSheet: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
//           child: TextField(
//             decoration: InputDecoration(
//               contentPadding:
//                   EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//               filled: true,
//               fillColor: Colors.grey.shade50,
//               hintText: 'اكتب رسالتك هنا',
//               hintStyle: TextStyle(color: Colors.grey.shade400),
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.black12)),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.black12)),
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 28.0),
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(15),
//                       child: Text(
//                         'السلام عليك ورحمة الله وبركاتة من فضلك لدي اقتراح من اجل تحسين خدمة مقدمة في البرنامج',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       decoration: BoxDecoration(
//                           color: Color(Constants.mainColor),
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(10),
//                               topLeft: Radius.circular(10),
//                               bottomLeft: Radius.circular(10))),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           '02:21PM',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Icon(
//                           FontAwesomeIcons.checkDouble,
//                           size: 15,
//                           color: Colors.orange,
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(15),
//                       child: Text(
//                         'انا شاكرة جدا..ان شاء الله طلبك لن يتأخر',
//                         style: TextStyle(color: Colors.black87, fontSize: 16),
//                       ),
//                       decoration: BoxDecoration(
//                           color: Color(0xffDBE2ED),
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(10),
//                               bottomLeft: Radius.circular(10),
//                               bottomRight: Radius.circular(10))),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           '02:21PM',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
