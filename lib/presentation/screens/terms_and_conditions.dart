import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/constants.dart';

class ConditionsAndRules extends StatefulWidget {
  @override
  _ConditionsAndRulesState createState() => _ConditionsAndRulesState();
}

class _ConditionsAndRulesState extends State<ConditionsAndRules> {
  Color colorGreen = Color(0xff119546);
  onBackPressed(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  String? terms;
  bool circularIndicatorActive = true;
  bool loading = false;
  int lan = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTerms();
  }

  Future getTerms() async {
    setState(() {
      loading = true;
    });
    var response = await Dio().get("https://toot.work/api/terms");
    setState(() {
      terms = response.data.toString();
      loading = false;
    });
  }

  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorGreen,
        textColor: Colors.white,
        fontSize: 16.0);
    // _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('الشروط والاحكام'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(Constants.mainColor),
          elevation: 5.0,
        ),
        body: loading
            ? Center(
                child: Container(
                height: 100,
                width: 100,
                child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
              ))
            : SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Html(
                    data: terms,
                  ),
                ),
              ));
  }
}
