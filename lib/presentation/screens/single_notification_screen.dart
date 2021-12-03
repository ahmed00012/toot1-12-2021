import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';

import '../../constants.dart';

class SingleNotificationScreen extends StatelessWidget {
  final String title;
  final String details;
  final String image;
  final int id;
  SingleNotificationScreen(
      {required this.id,
      required this.image,
      required this.title,
      required this.details});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        title: 'تنبيه جديد',
        isBack: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0.04.sh),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: image != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        child: Image.network(
                          image,
                          width: 1.sw,
                          height: 0.3.sh,
                          fit: BoxFit.cover,
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        child: Image.asset(
                          "assets/images/دون صوره.png",
                          width: 1.sw,
                          height: 200,
                          fit: BoxFit.fill,
                        )),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Color(Constants.mainColor),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w100),
              ),
              Text(
                details,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
