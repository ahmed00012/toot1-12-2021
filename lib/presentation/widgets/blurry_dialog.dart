import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: Center(
              child: Text(title, style: TextStyle(color: Colors.red.shade400))),
          content: Text(
            content,
            style: TextStyle(color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('موافق'),
                onPressed: () {
                  continueCallBack();
                },
              ),
            ),
          ],
        ));
  }
}
