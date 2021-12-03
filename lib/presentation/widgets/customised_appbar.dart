import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class BuildAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool? isBack;
  BuildAppBar({required this.title, this.isBack = true});

  @override
  Size get preferredSize => Size.fromHeight(0.08.sh);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      leading: Visibility(
        visible: !isBack!,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      toolbarHeight: 0.15.sh,
      backgroundColor: Color(Constants.mainColor),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
    );
  }
}
