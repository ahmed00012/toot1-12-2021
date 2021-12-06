import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/constants.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';

class Review extends StatefulWidget {
  String? vendorID;
  String? token;
  String? orderId;
  Review({this.token, this.vendorID, this.orderId});
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  int branchRating = 3;
  int foodRating = 3;
  int priceRating = 3;
  TextEditingController tECComment = new TextEditingController();

  @override
  void initState() {
    super.initState();

    //_rating = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'تقييم الخدمة',
          ),
          centerTitle: true,
          backgroundColor: Color(Constants.mainColor),
          elevation: 5.0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'من فضلك قم بتقييم الخدمة',
                    style: TextStyle(color: Color(Constants.mainColor)),
                  ),
                  Container(
                      height: 180,
                      child: Lottie.asset('assets/images/lf20_k9k3vues.json',
                          fit: BoxFit.cover)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                'درجة رضاك عن خدمتنا',
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      branchRating = rating.toInt();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Text(
                'سرعة توصيل الطلب',
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      foodRating = rating.toInt();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Text(
                'جودة المنتجات',
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      priceRating = rating.toInt();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                child: Stack(
                  children: <Widget>[
                    //خلفية الكارت
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            //مستوى الوضوح مع اللون
                            color: Colors.grey.withOpacity(0.7),
                            //مدى انتشارة
                            spreadRadius: 2,
                            //مدى تقلة
                            blurRadius: 5,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    //المحتوى
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(
                              MediaQuery.of(context).size.width / 20),
                          child: TextField(
                            controller: tECComment,
                            decoration: new InputDecoration(
                              hintText: 'ملاحظات او اقتراحات لتحسين الخدمة...',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 30),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                            ),
                            cursorColor: Colors.indigo,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 3.5,
                    MediaQuery.of(context).size.width / 10,
                    MediaQuery.of(context).size.width / 3.5,
                    0.0),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width / 3,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  height: MediaQuery.of(context).size.width / 8,
                  child: RaisedButton(
                    child: Text('ارسال',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20,
                            color: Colors.white)),
                    color: Colors.indigo,
                    onPressed: () {
                      senToRate();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }

  void senToRate() async {
    var response = await http
        .post(Uri.parse("https://toot.work/api/rate/vendor"), headers: {
      "Authorization": "Bearer ${widget.token}",
    }, body: {
      "vendor_id": widget.vendorID.toString(),
      "rate_vendor": branchRating.toString(),
      "rate_taste": foodRating.toString(),
      "rate_price": priceRating.toString(),
      "comment": tECComment.text,
      "order_id": widget.orderId.toString()
    });

    var datauser = json.decode(response.body);

    if ("${datauser['success']}" == "1") {
      displayToastMessage(' سعدنا بخدمتكم');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
          (Route<dynamic> route) => false);
    }
  }

  void displayToastMessage(var toastMessage) {
    // Fluttertoast.showToast(
    //     msg: toastMessage.toString(),
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
    showSimpleNotification(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              toastMessage,
              style: TextStyle(
                  color: Color(Constants.mainColor),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        background: Colors.white);
  }
}
