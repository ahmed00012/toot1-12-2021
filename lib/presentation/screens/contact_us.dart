// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:toot/constants.dart';
//
// class Comment extends StatefulWidget {
//   @override
//   _CommentState createState() => _CommentState();
// }
//
// class _CommentState extends State<Comment> {
//   TextEditingController tECCommentSubject = new TextEditingController();
//   TextEditingController tECComment = new TextEditingController();
//   TextEditingController phone = new TextEditingController();
//   TextEditingController name = new TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   sendData() async {
//     var response =
//         await Dio().post("https://toot.work/api/settings/contactus", data: {
//       "title": tECCommentSubject.text,
//       "message": tECComment.text,
//     });
//     var data = response.data;
//     if ("${data['success']}" == "1") {
//       displayToastMessage(data['message'].toString());
//     } else {
//       displayToastMessage(data['message'].toString());
//     }
//   }
//
//   onBackPressed(BuildContext context) async {
//     Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => onBackPressed(context),
//       child: Scaffold(
//         appBar: new AppBar(
//           backgroundColor: Color(Constants.mainColor),
//           title: Text(
//             'اتصل بنا',
//           ),
//           centerTitle: true,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back),
//           ),
//         ),
//         body: Container(
//           color: Color(0xfff8f9f9),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   alignment: Alignment.center,
//                   margin:
//                       EdgeInsets.all(MediaQuery.of(context).size.width / 12),
//                   child: Text('اترك رسالتك',
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.width / 25,
//                           color: Colors.black)),
//                 ),
//                 Container(
//                   margin:
//                       EdgeInsets.all(MediaQuery.of(context).size.width / 20),
//                   child: Stack(
//                     children: <Widget>[
//                       //المحتوى
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height / 10,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   //مستوى الوضوح مع اللون
//                                   color: Colors.grey.withOpacity(0.7),
//                                   //مدى انتشارة
//                                   spreadRadius: 2,
//                                   //مدى تقلة
//                                   blurRadius: 5,
//                                   offset: Offset(
//                                       0, 2), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             padding: EdgeInsets.all(
//                                 MediaQuery.of(context).size.width / 30),
//                             child: TextFormField(
//                               controller: name,
//                               decoration: new InputDecoration(
//                                 hintText: "الاسم",
//                                 hintStyle: TextStyle(
//                                     color: Colors.black,
//                                     fontSize:
//                                         MediaQuery.of(context).size.width / 30),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                               ),
//                               cursorColor: Color(Constants.mainColor),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'هذا الحقل مطلوب';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 Container(
//                   margin:
//                       EdgeInsets.all(MediaQuery.of(context).size.width / 20),
//                   child: Stack(
//                     children: <Widget>[
//                       //المحتوى
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height / 10,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   //مستوى الوضوح مع اللون
//                                   color: Colors.grey.withOpacity(0.7),
//                                   //مدى انتشارة
//                                   spreadRadius: 2,
//                                   //مدى تقلة
//                                   blurRadius: 5,
//                                   offset: Offset(
//                                       0, 2), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             padding: EdgeInsets.all(
//                                 MediaQuery.of(context).size.width / 30),
//                             child: TextFormField(
//                               controller: phone,
//                               keyboardType: TextInputType.phone,
//                               decoration: new InputDecoration(
//                                 hintText: "رقم الهاتف",
//                                 hintStyle: TextStyle(
//                                     color: Colors.black,
//                                     fontSize:
//                                         MediaQuery.of(context).size.width / 30),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                               ),
//                               cursorColor: Color(Constants.mainColor),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'هذا الحقل مطلوب';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 //Subject
//                 Container(
//                   margin:
//                       EdgeInsets.all(MediaQuery.of(context).size.width / 20),
//                   child: Stack(
//                     children: <Widget>[
//                       //المحتوى
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height / 10,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   //مستوى الوضوح مع اللون
//                                   color: Colors.grey.withOpacity(0.7),
//                                   //مدى انتشارة
//                                   spreadRadius: 2,
//                                   //مدى تقلة
//                                   blurRadius: 5,
//                                   offset: Offset(
//                                       0, 2), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             padding: EdgeInsets.all(
//                                 MediaQuery.of(context).size.width / 30),
//                             child: TextFormField(
//                               controller: tECCommentSubject,
//                               decoration: new InputDecoration(
//                                 hintText: "الموضوع",
//                                 hintStyle: TextStyle(
//                                     color: Colors.black,
//                                     fontSize:
//                                         MediaQuery.of(context).size.width / 30),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                               ),
//                               cursorColor: Color(Constants.mainColor),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'هذا الحقل مطلوب';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 //Message
//                 Container(
//                   margin:
//                       EdgeInsets.all(MediaQuery.of(context).size.width / 20),
//                   child: Stack(
//                     children: <Widget>[
//                       //المحتوى
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height / 7,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   //مستوى الوضوح مع اللون
//                                   color: Colors.grey.withOpacity(0.7),
//                                   //مدى انتشارة
//                                   spreadRadius: 2,
//                                   //مدى تقلة
//                                   blurRadius: 5,
//                                   offset: Offset(
//                                       0, 2), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             padding: EdgeInsets.all(
//                                 MediaQuery.of(context).size.width / 30),
//                             child: TextFormField(
//                               controller: tECComment,
//                               decoration: new InputDecoration(
//                                 hintText: "أضف سؤال أو استفسار...",
//                                 hintStyle: TextStyle(
//                                     color: Colors.black,
//                                     fontSize:
//                                         MediaQuery.of(context).size.width / 30),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color(Constants.mainColor)),
//                                 ),
//                               ),
//                               cursorColor: Color(Constants.mainColor),
//                               maxLines: 3,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'هذا الحقل مطلوب';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 //SEND
//                 Container(
//                   margin: EdgeInsets.fromLTRB(
//                       MediaQuery.of(context).size.width / 3.5,
//                       MediaQuery.of(context).size.width / 10,
//                       MediaQuery.of(context).size.width / 3.5,
//                       0.0),
//                   child: ButtonTheme(
//                     minWidth: MediaQuery.of(context).size.width / 3,
//                     shape: new RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(10.0)),
//                     height: MediaQuery.of(context).size.width / 8,
//                     child: RaisedButton(
//                       child: Text("ارسل",
//                           style: TextStyle(
//                               fontSize: MediaQuery.of(context).size.width / 20,
//                               color: Colors.white)),
//                       color: Color(Constants.mainColor),
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           sendData();
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void displayToastMessage(var toastMessage) {
//     // Fluttertoast.showToast(
//     //     msg: toastMessage.toString(),
//     //     toastLength: Toast.LENGTH_SHORT,
//     //     gravity: ToastGravity.BOTTOM,
//     //     textColor: Colors.white,
//     //     fontSize: 16.0);
//     showSimpleNotification(
//         Container(
//           height: 50,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(
//               toastMessage,
//               style: TextStyle(
//                   color: Color(Constants.mainColor),
//                   fontSize: 18,
//                   fontFamily: 'Tajawal',
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         duration: Duration(seconds: 3),
//         background: Colors.white);
//     tECCommentSubject.text = '';
//     tECComment.text = '';
//   }
// }
