import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        navigationDelegate: (request) {
          if (request.url.contains('success')) {
            BlocProvider.of<CartCubit>(context)
                .confirmCardOrder()
                .then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
                  (Route route) => false);
            });
          } else {
            Navigator.pop(context);
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
