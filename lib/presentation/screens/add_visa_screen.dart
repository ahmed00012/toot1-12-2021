import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AddVisaScreen extends StatefulWidget {
  @override
  State<AddVisaScreen> createState() => _AddVisaScreenState();
}

class _AddVisaScreenState extends State<AddVisaScreen> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'اضافة فيزا',
              style: TextStyle(
                  color: Color(Constants.mainColor),
                  fontWeight: FontWeight.w300),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                size: 25,
                color: Color(Constants.mainColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                CreditCard(
                  cardNumber: cardNumber,
                  cardExpiry: expiryDate,
                  cardHolderName: cardHolderName,
                  cvv: cvv,
                  bankName: 'Axis Bank',
                  showBackSide: showBack,
                  frontBackground: CardBackgrounds.black,
                  backBackground: CardBackgrounds.white,
                  showShadow: true,
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'رقم البطاقة',
                            focusColor: Color(Constants.mainColor)),
                        maxLength: 16,
                        onChanged: (value) {
                          setState(() {
                            cardNumber = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'تاريخ الانتهاء',
                            focusColor: Color(Constants.mainColor)),
                        maxLength: 5,
                        onChanged: (value) {
                          setState(() {
                            expiryDate = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'اسم حامل البطاقة',
                            focusColor: Color(Constants.mainColor)),
                        onChanged: (value) {
                          setState(() {
                            cardHolderName = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'CVV',
                            focusColor: Color(Constants.mainColor)),
                        maxLength: 3,
                        onChanged: (value) {
                          setState(() {
                            cvv = value;
                          });
                        },
                        focusNode: _focusNode,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
