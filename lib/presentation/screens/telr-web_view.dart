import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/constants.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'order_confirmation.dart';

class TelrWebView extends StatefulWidget {
  String? url;
  TelrWebView({this.url});
  @override
  TelrWebViewState createState() => TelrWebViewState();
}

class TelrWebViewState extends State<TelrWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اتمام الدفع'),
        centerTitle: true,
        backgroundColor: Color(Constants.mainColor),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url){
         if(url.contains('success')) {
               BlocProvider.of<CartCubit>(context)
                   .confirmCardOrder()
                   .then((value) {
                 Navigator.pushAndRemoveUntil(
                     context,
                     MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
                     (Route route) => false);
               });
          } else if(url.contains('declined'))
         {          showSimpleNotification(

                   Container(
                     height: 50,
                     child: Padding(
                         padding: const EdgeInsets.only(top: 5.0),
                         child: Column(
                           children: [
                             Text(
                               'عذرا ! عملية مرفوضة',
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold),
                             ),
                           ],
                         )),
                   ),
                   duration: Duration(seconds: 3),
                   background: Colors.red,
                 );
         Navigator.pop(context);
         }
        },
        //////ANDROID/////
        // navigationDelegate: (request) {
        //   if (request.url.contains('success')) {
        //     BlocProvider.of<CartCubit>(context)
        //         .confirmCardOrder()
        //         .then((value) {
        //       Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
        //           (Route route) => false);
        //     });
        //   }


        //   return NavigationDecision.navigate;
        // },
      ),
    );
  }
}
