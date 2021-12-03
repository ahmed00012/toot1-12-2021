import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/presentation/screens/auth_screen.dart';
import 'package:toot/presentation/screens/cart_screen.dart';
import 'package:toot/presentation/screens/favorites_screen.dart';
import 'package:toot/presentation/screens/home_screen.dart';
import 'package:toot/presentation/screens/notifications_screen.dart';
import 'package:toot/presentation/screens/orders_details_screen.dart';
import 'package:toot/presentation/screens/orders_screen.dart';
import 'package:toot/presentation/screens/review.dart';
import 'package:toot/presentation/screens/settings_screen.dart';

import '../../constants.dart';
import 'blurry_dialog.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? animation;
  late CurvedAnimation curve;
  PageController _pageController = PageController(initialPage: 0);
  int? currentTab;
  final autoSizeGroup = AutoSizeGroup();
  bool isLogin = false;

  final List<IconData> iconList = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.solidHeart,
    FontAwesomeIcons.solidBell,
    FontAwesomeIcons.userCog,
  ];

  final iconTitlesAR = <String>[
    'الرئيسية',
    'المفضلة',
    'التنبيهات',
    'الاعدادات',
  ];

  List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    NotificationScreen(),
    SettingsScreen(),
    OrdersScreen(),
    OrdersDetailsScreen(
      id: 0,
    ),
  ];

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  void initState() {
    currentTab = 0;
    LocalStorage.getData(key: 'isLogin') != null
        ? isLogin = LocalStorage.getData(key: 'isLogin')
        : isLogin = false;
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    fcmNotification();
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
    super.initState();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  fcmNotification() async {
    //FCM
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    });
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification!.android;
      print('efweferw' + message.data.toString());
      if (notification != null && android != null) {
        final order =
            message.notification!.body!.replaceAll(RegExp('[^0-9]'), '');
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                notification.title!,
                notification.body!,
                icon: 'app_icon',
              ),
            ));
        if (message.notification!.title == "تقيم الخدمة") {
          showSimpleNotification(
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrdersDetailsScreen(
                              id: int.parse(order),
                            )));
              },
              child: Container(
                height: 67,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            background: Colors.green,
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Review(
                        vendorID: message.data['vendor_id'],
                        token: LocalStorage.getData(key: 'token'),
                        orderId: message.data['type_id'],
                      )));
        } else if (message.notification!.title == "تغير حالة الطلب") {
          showSimpleNotification(
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrdersDetailsScreen(
                              id: int.parse(order),
                            )));
              },
              child: Container(
                height: 67,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            background: Colors.green,
          );
        } else
          showSimpleNotification(
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()));
              },
              child: Container(
                height: 65,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            background: Colors.green,
          );
      }
    });

    //ديه بتفتح التطبيق وتقيم الخدمة
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final order =
          message.notification!.body!.replaceAll(RegExp('[^0-9]'), '');
      print(
          'A new onMessageOpenedApp event was published Message ${message.notification!.title} ');
      if (message.notification!.title == "تقيم الخدمة") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Review(
                      vendorID: message.data['vendor_id'],
                      token: LocalStorage.getData(key: 'token'),
                      orderId: message.data['type_id'],
                    )));
      } else if (message.notification!.title == "تغير حالة الطلب") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrdersDetailsScreen(
                      id: int.parse(order),
                    )));
      } else
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
    });

    FirebaseMessaging.instance.getToken().then((value) {
      print("FIREBASE TOKEN $value");
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentTab = index;
          });
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: animation!,
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Color(Constants.mainColor),
            child: Icon(
              Icons.shopping_cart,
              size: 28,
            ),
            onPressed: () async {
              if (!isLogin)
                _showDialog(
                    context, 'لا يمكن عرض الطلبات يجب عليك التسجيل اولا');
              else
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
            },
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      extendBody: true,
      bottomNavigationBar: Container(
        height: 70,
        child: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? Color(Constants.mainColor) : Colors.grey;
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      iconList[index],
                      color: color,
                      size: 20,
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: AutoSizeText(
                        // Localizations.localeOf(context).languageCode == "ar"
                        //     ? iconTitlesAr[index]
                        iconTitlesAR[index],
                        maxLines: 1,
                        style: TextStyle(color: color, fontSize: 8),
                        group: autoSizeGroup,
                      ),
                    )
                  ],
                ),
              );
            },
            backgroundColor: Colors.white,
            activeIndex: currentTab!,
            splashColor: Color(Constants.mainColor),
            notchAndCornersAnimation: animation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.softEdge,
            gapLocation: GapLocation.center,
            height: MediaQuery.of(context).size.height * 0.1,
            // leftCornerRadius: 32,
            // rightCornerRadius: 32,
            onTap: (index) async {
              if (!isLogin) {
                if (index == 1)
                  _showDialog(
                      context, 'لا يمكن عرض المفضلة يجب عليك التسجيل اولا');
                else if (index == 2)
                  _showDialog(
                      context, 'لا يمكن عرض التنبيهات يجب عليك التسجيل اولا');
                else
                  setState(() {
                    this._onItemTapped(index);
                  });
              } else {
                setState(() {
                  this._onItemTapped(index);
                });
              }
            }),
      ),
    );
  }
}
