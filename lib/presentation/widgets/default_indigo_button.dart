import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class BuildIndigoButton extends StatelessWidget {
  final String title;
  final Function function;
  BuildIndigoButton({required this.title, required this.function});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.06.sh,
      width: 0.85.sw,
      child: ElevatedButton.icon(
        onPressed: () {
          return function();
        },
        icon: Icon(
          Icons.arrow_forward,
          size: 20,
        ),
        label: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(Constants.mainColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
