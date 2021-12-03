import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/presentation/screens/auth_screen.dart';
import 'package:toot/presentation/screens/orders_screen.dart';
import 'package:toot/presentation/screens/points_screen.dart';
import 'package:toot/presentation/screens/terms_and_conditions.dart';
import 'package:toot/presentation/screens/update_profile.dart';
import 'package:toot/presentation/widgets/blurry_dialog.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  _showDialog(BuildContext context, String title) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AuthScreen())),
          // code on continue comes here
        };
    BlurryDialog alert = BlurryDialog('التسجيل اولا', title, continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _launchURL() async => await canLaunch(
          "https://wa.me/+201116657728/?text=${Uri.parse('hello')}")
      ? await launch("https://wa.me/+201116657728/?text=${Uri.parse("hello")}")
      : throw 'Could not launch "https://wa.me/+201116657728/?text=${Uri.parse("hello")}"';

  @override
  Widget build(BuildContext context) {
    String? name = LocalStorage.getData(key: 'name');
    String? phone = LocalStorage.getData(key: 'phone');
    String? identity = LocalStorage.getData(key: 'identity');
    bool? login = LocalStorage.getData(key: 'isLogin') ?? false;
    return Scaffold(
      appBar: BuildAppBar(
        title: 'الاعدادات',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // SettingsItem(
              //   title: 'حسابي',
              //   image: 'assets/images/icon-account.png',
              //   function: () {
              //     Navigator.of(context)
              //         .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
              //   },
              // ),

              Container(
                height: 70,
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.indigo)),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.indigo,
                        )

                        // Image.asset(
                        //   "assets/images/user.png",
                        // ) ,
                        ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 25,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name == '' || name == null ? '' : name,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          phone == '' || phone == null
                              ? ''
                              : phone.substring(5),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Tajawal'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              login!
                  ? SettingsItem(
                      title: 'طلباتي',
                      image: 'assets/images/icon-cart.png',
                      function: () {
                        if ((LocalStorage.getData(key: 'token') == '' ||
                            LocalStorage.getData(key: 'token') == null)) {
                          _showDialog(context,
                              'لا يمكن عرض المفضلة يجب عليك التسجيل اولا');
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => OrdersScreen()));
                        }
                      },
                    )
                  : Container(),
              SettingsItem(
                title: 'نشر التطبيق',
                image: 'assets/images/icon-share.png',
                function: () {
                  Share.share('قم بتحميل ابلكيشن توت واطلب كل ما يلزمك',
                      subject: 'قم بتحميل ابلكيشن توت واطلب كل ما يلزمك');
                },
              ),
              // SettingsItem(
              //   title: 'انضم الينا',
              //   image: 'assets/images/icon-mail.png',
              // ),
              // login
              //     ? SettingsItem(
              //         title: 'محادثات',
              //         image: 'assets/images/add card  (4).png',
              //         function: () {
              //           Navigator.of(context).push(
              //               MaterialPageRoute(builder: (_) => ChatScreen()));
              //         },
              //       )
              //     : Container(),
              login
                  ? SettingsItem(
                      title: 'نقاطي',
                      image: 'assets/images/cdf.png',
                      function: () {
                        print(LocalStorage.getData(key: 'token'));
                        if ((LocalStorage.getData(key: 'token') == '' ||
                            LocalStorage.getData(key: 'token') == null)) {
                          _showDialog(context,
                              'لا يمكن عرض المفضلة يجب عليك التسجيل اولا');
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PointsScreen()));
                        }
                      },
                    )
                  : Container(),
              login
                  ? SettingsItem(
                      title: 'تعديل بياناتي',
                      image: 'assets/images/edit.png',
                      function: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => UpdateProfile(
                                  name: name,
                                  identity: identity,
                                )));
                      },
                    )
                  : Container(),
              SettingsItem(
                title: 'مساعدة',
                image: 'assets/images/Group 1302.png',
                function: () {
                  _launchURL();
                },
              ),
              SettingsItem(
                title: 'الشروط والاحكام',
                image: 'assets/images/icon-account.png',
                function: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ConditionsAndRules()));
                },
              ),
              login
                  ? SettingsItem(
                      title: 'تسجيل الخروج',
                      image: 'assets/images/icon-sign-out.png',
                      function: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AuthScreen()),
                            (Route<dynamic> route) => false);
                        // LocalStorage.removeData(key: 'token');
                        // LocalStorage.removeData(key: 'cart_token');
                        LocalStorage.saveData(key: 'isLogin', value: false);
                        LocalStorage.saveData(key: 'token', value: '');
                        LocalStorage.saveData(key: 'cart_token', value: '');
                        LocalStorage.saveData(key: 'phone', value: '');
                        LocalStorage.saveData(key: 'name', value: '');
                        LocalStorage.saveData(key: 'counter', value: 0);
                      },
                    )
                  : SettingsItem(
                      title: 'تسجيل الدخول',
                      image: 'assets/images/enter.png',
                      function: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AuthScreen()),
                            (Route<dynamic> route) => false);
                      },
                    ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String image;
  final Function? function;
  SettingsItem({required this.title, required this.image, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return function!();
      },
      child: Container(
        height: 0.075.sh,
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xffDBE2ED),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 0.05.sw,
              fit: BoxFit.cover,
              color: Colors.grey.shade700,
            ),
            SizedBox(
              width: 0.04.sw,
            ),
            Text(title),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}
