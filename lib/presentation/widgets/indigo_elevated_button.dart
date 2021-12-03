import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class BuildElevatedButton extends StatelessWidget {
  final String title;
  final Function function;
  BuildElevatedButton({required this.function, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.41.sw,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          return function();
        },
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(Constants.mainColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
