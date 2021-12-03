import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/constants.dart';
import 'package:toot/cubits/product_cubit/product_cubit.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/presentation/screens/review.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';

import 'categories_screen.dart';
import 'notifications_screen.dart';
import 'orders_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  DateTime? currentBackPressTime;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  getLocalStorage() async {
    await LocalStorage.init();
    print('home storage init');
  }

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

  _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: const Text(
                  'عفوا',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              content: Text(
                'لا يوجد اتصال بالانترنت',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'حسنا',
                    style: TextStyle(color: Color(0xff7C39CB)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBar()));
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  void initState() {
    _checkInternet();
    getLocalStorage();
    // fcmNotification();
    BlocProvider.of<ProductCubit>(context).fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 3)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: "اضعط مرتين للخروج من التطبيق");
          return Future.value(false);
        } else
          exit(0);
      },
      child: Scaffold(
          appBar: BuildAppBar(
            title: 'المتجر',
          ),
          body: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
            if (state is CategoriesLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoriesScreen(
                                shopId: state.items![current].id!,
                                shopName: state.items![current].name!),
                          ),
                        );
                        // Navigator.of(context)
                        //     .push(MaterialPageRoute(
                        //         builder: (_) => SingleItemScreen(
                        //               id: state.items![current].id!,
                        //               title: state.items![current].name,
                        //               price: double.parse(
                        //                   state.items![current].price!),
                        //               shopId: state.items![current].vendorID,
                        //               // isFav: state.items[current].inFavourite == 1
                        //               //     ? true
                        //               //     : false,
                        //               fromPanner: true,
                        //             )))
                        //     .then((value) =>
                        //         BlocProvider.of<ProductCubit>(context).emit(
                        //             CategoriesLoaded(
                        //                 categories: state.items!)));
                      },
                      child: Center(
                        child: CarouselSlider.builder(
                          itemCount: state.items!.length,
                          options: CarouselOptions(
                              height: 0.25.sh,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 4),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  current = index;
                                });
                              }),
                          itemBuilder: (ctx, index, _) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: state.items![index].imageOne != null
                                      ? Image.network(
                                          state.items![index].imageOne!,
                                          fit: BoxFit.fill,
                                          width: 0.8.sw,
                                        )
                                      : Image.asset(
                                          'assets/images/00vv63.jpg',
                                          fit: BoxFit.fill,
                                          width: 0.8.sw,
                                        )),
                            );
                          },
                        ),
                      ),
                    ),
                    ShopsListView(
                      categories: state.categories,
                      function: () {
                        BlocProvider.of<ProductCubit>(context).emit(
                            CategoriesLoaded(
                                categories: state.categories,
                                items: state.items));
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                  child: Container(
                height: 120,
                width: 120,
                child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
              ));
            }
          })),
    );
  }
}

class ShopsListView extends StatelessWidget {
  ShopsListView({required this.categories, required this.function});

  final List<dynamic> categories;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: categories.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            height: 0.28.sh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: categories[index].image != null
                            ? Image.network(
                                categories[index].image,
                                height: 30,
                                width: 30,
                              )
                            : Image.asset(
                                'assets/images/1024.png',
                                height: 30,
                                width: 30,
                              ),
                      ),
                      Text(
                        categories[index].categoryName ?? '',
                        style: TextStyle(
                            color: Color(Constants.mainColor),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: categories[index].markets!.length,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, imagesIndex) {
                        return GestureDetector(
                          onTap: () {
                            if (categories[index]
                                    .markets[imagesIndex]
                                    .isReciving ==
                                1) {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => CategoriesScreen(
                                      shopId: categories[index]
                                          .markets![imagesIndex]
                                          .id,
                                      shopName: categories[index]
                                          .markets![imagesIndex]
                                          .name),
                                ),
                              )
                                  .then((value) {
                                return function();
                              });
                            } else
                              showSimpleNotification(
                                  Container(
                                    height: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'عذرا هذا الفرع لا يستقبل طلبات حاليا',
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                  background: Colors.white);
                          },
                          child: Container(
                            width: 0.8.sw,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: categories[index]
                                            .markets![imagesIndex]
                                            .image !=
                                        null
                                    ? CachedNetworkImage(
                                        imageUrl: categories[index]
                                            .markets![imagesIndex]
                                            .image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          alignment: Alignment.bottomRight,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 0.04.sh,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Colors.black45,
                                                  Colors.black12
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 5),
                                              child: Text(
                                                categories[index]
                                                    .markets![imagesIndex]
                                                    .name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/images/00vv63.jpg',
                                          fit: BoxFit.cover,
                                          width: 0.6.sw,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/eCommerce-Shop.png',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/00vv63.jpg',
                                        fit: BoxFit.cover,
                                      )),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
