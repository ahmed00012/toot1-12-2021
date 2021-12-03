import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsBool = false;
  bool newslettersBool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        title: 'حسابي',
        isBack: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.08.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'معلوماتك',
                  style:
                      TextStyle(fontSize: 24.sp, color: Colors.grey.shade700),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.04.sw, vertical: 0.02.sh),
                  height: 0.43.sh,
                  width: 0.85.sw,
                  decoration: BoxDecoration(
                      color: Color(0xffF0F4F8),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuildInfoItem(
                        title: 'الاسم بالكامل ',
                        detail: 'WORLD DESIGN',
                      ),
                      BuildInfoItem(
                        title: 'العنوان ',
                        detail: 'الرياض / السعودية',
                      ),
                      BuildInfoItem(
                        title: 'الايميل الالكتروني ',
                        detail: 'sales@world-designs.com ',
                      ),
                      BuildInfoItem(
                        title: 'كلمة السر',
                        detail: '**********',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 0.03.sh,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'اعداداتك',
                  style:
                      TextStyle(fontSize: 24.sp, color: Colors.grey.shade700),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 0.06.sw, vertical: 0.02.sh),
                height: 0.16.sh,
                width: 0.85.sw,
                decoration: BoxDecoration(
                    color: Color(0xffF0F4F8),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الاشعارات',
                          style: TextStyle(
                              fontSize: 20.sp, color: Colors.grey.shade700),
                        ),
                        FlutterSwitch(
                          width: 55,
                          height: 32,
                          toggleSize: 28.0,
                          value: notificationsBool,
                          borderRadius: 30.0,
                          padding: 0,
                          inactiveToggleColor: Color(Constants.mainColor),
                          activeToggleColor: Color(0xff748A9D),
                          activeSwitchBorder: Border.all(
                            color: Color(0xFF00D2B8),
                          ),
                          inactiveSwitchBorder: Border.all(
                            color: Color(Constants.mainColor),
                          ),
                          inactiveColor: Colors.white,
                          activeColor: Colors.white,
                          inactiveIcon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onToggle: (val) {
                            setState(() {
                              notificationsBool = val;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'اخر الاخبار',
                          style: TextStyle(
                              fontSize: 20.sp, color: Colors.grey.shade700),
                        ),
                        FlutterSwitch(
                          width: 55,
                          height: 32,
                          toggleSize: 28.0,
                          value: newslettersBool,
                          borderRadius: 30.0,
                          padding: 0,
                          inactiveToggleColor: Color(Constants.mainColor),
                          activeToggleColor: Color(0xff748A9D),
                          activeSwitchBorder: Border.all(
                            color: Color(0xFF00D2B8),
                          ),
                          inactiveSwitchBorder: Border.all(
                            color: Color(Constants.mainColor),
                          ),
                          inactiveColor: Colors.white,
                          activeColor: Colors.white,
                          inactiveIcon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          activeIcon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onToggle: (val) {
                            setState(() {
                              newslettersBool = val;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BuildInfoItem extends StatelessWidget {
  final TextStyle titleStyle =
      TextStyle(fontSize: 18.sp, color: Colors.grey.shade700);
  final TextStyle detailStyle =
      TextStyle(fontSize: 16.sp, color: Colors.grey.shade500);
  final String title;
  final String detail;
  BuildInfoItem({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle,
              ),
              Text(
                detail,
                style: detailStyle,
              ),
            ],
          ),
          Spacer(),
          Image.asset('assets/images/icon-edit.png')
        ],
      ),
    );
  }
}
