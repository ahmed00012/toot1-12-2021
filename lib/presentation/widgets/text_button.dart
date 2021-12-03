import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTextButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  BuildTextButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: TextButton(
        onPressed: () {
          return onPressed();
        },
        child: Text(
          title,
          style:
              TextStyle(color: Color(0xffA6BCD0), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
