import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:toot/cubits/product_cubit/product_cubit.dart';
import 'package:toot/presentation/screens/cart_screen.dart';
import 'package:toot/presentation/screens/splash_screen.dart';

import 'cubits/auth_cubit/auth_cubit.dart';
import 'cubits/bloc_observer.dart';
import 'cubits/cart_cubit/cart_cubit.dart';
import 'data/local_storage.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications',
//     description: // title
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);
//
// /// This is called on the beginning of main() to ensure when app is closed
// /// user receives the notifications. Then it's called also in the build method of MyApp
// /// so user receives foreground notifications.
// Future<void> showNotification(RemoteMessage message) async {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//
//   if (notification != null && android != null) {
//     localNotifications.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           icon: android.smallIcon,
//         ),
//       ),
//     );
//   }
// }

/// This is called when user clicks on the notification
// Future<void> onNotificationClick(RemoteMessage? message) async {
//   if (message == null || message.data == null) {
//     return;
//   }
//
//   final Map data = message?.data;
//
//
//
//   if (data['screen'] != null && data['screen_args'] != null) {
//     switch (message.data['screen']) {
//       case 'PostScreen':
//         PostsProvider _postsProvider = Provider.of(
//           navigatorKey.currentContext,
//           listen: false,
//         );
//
//         _postsProvider.fetchPosts(reload: true).then((List<Post> posts) {
//           Post post = posts.firstWhere((element) {
//             Map<String, dynamic> _screenArgs =
//                 jsonDecode(message.data['screen_args']);
//             return element.id == _screenArgs['post'];
//           });
//           Navigator.of(navigatorKey.currentContext)
//               .pushNamed('/post', arguments: {
//             'post': post,
//           });
//         });
//
//         break;
//     }
//   }
// }

// final FlutterLocalNotificationsPlugin localNotifications =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await LocalStorage.init();
  await Firebase.initializeApp();

  // await localNotifications
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // Permissions for background notifications
  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  //
  // // Permissions for foreground notifications
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // var initializationSettingsAndroid =
  //     new AndroidInitializationSettings('@mipmap/ic_launcher');
  // // Local notification settings, which allows to make foreground notifications
  // await localNotifications.initialize(InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: IOSInitializationSettings(),
  // ));
  //
  // // FirebaseMessaging.onMessageOpenedApp.listen(onNotificationClick);
  // // FirebaseMessaging.instance.getInitialMessage().then(onNotificationClick);
  // FirebaseMessaging.onBackgroundMessage(showNotification);

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [
      Locale('ar'),
      Locale('en')
    ], //must be in this arrangement
    path: "assets/lang",
    startLocale: Locale('ar'),
    saveLocale: true,
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((token) {
      LocalStorage.saveData(key: 'token_fcm', value: token);
    });
    // fcmNotification();
    super.initState();
  }

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     new FlutterLocalNotificationsPlugin();
  // fcmNotification() async {
  //   //FCM
  //   FirebaseMessaging.instance
  //       .getInitialMessage()
  //       .then((RemoteMessage? message) {
  //     if (message != null) {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => BottomNavBar()));
  //     }
  //   });
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   await messaging.setForegroundNotificationPresentationOptions(
  //     alert: true, // Required to display a heads up notification
  //     badge: true,
  //     sound: true,
  //   );
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification notification = message.notification!;
  //     AndroidNotification? android = message.notification!.android;
  //     print('efweferw' + message.data.toString());
  //     if (notification != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               notification.title!,
  //               notification.body!,
  //               // TODO add a proper drawable resource to android, for now using
  //               //      one that already exists in example app.
  //               icon: 'app_icon',
  //             ),
  //           ));
  //       if (message.notification!.title == "تقيم الخدمة") {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => Review(
  //                       vendorID: message.data['vendor_id'],
  //                       token: LocalStorage.getData(key: 'token'),
  //                       orderId: message.data['type_id'],
  //                     )));
  //       }
  //     }
  //   });
  //
  //   //ديه بتفتح التطبيق وتقيم الخدمة
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     final order =
  //         message.notification!.body!.replaceAll(RegExp('[^0-9]'), '');
  //     print(
  //         'A new onMessageOpenedApp event was published Message ${message.notification!.title} ');
  //     if (message.notification!.title == "تقيم الخدمة") {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => Review(
  //                     vendorID: message.data['vendor_id'],
  //                     token: LocalStorage.getData(key: 'token'),
  //                     orderId: message.data['type_id'],
  //                   )));
  //     } else if (message.notification!.title == "تغير حالة الطلب") {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => OrdersDetailsScreen(
  //                     id: int.parse(order),
  //                   )));
  //     } else
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => NotificationScreen()));
  //   });
  //
  //   FirebaseMessaging.instance.getToken().then((value) {
  //     print("FIREBASE TOKEN $value");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // FirebaseMessaging.onMessage.listen(showNotification);
    // FirebaseMessaging.onMessageOpenedApp.listen(onNotificationClick);
    // FirebaseMessaging.instance.getInitialMessage().then(onNotificationClick);
    return ScreenUtilInit(
      designSize: Size(411, 683),
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
          ),
          BlocProvider<ProductCubit>(
            create: (context) => ProductCubit(),
          ),
          BlocProvider<FavoritesCubit>(
            create: (context) => FavoritesCubit(),
          ),
          BlocProvider<CartCubit>(
            create: (context) => CartCubit(),
          ),
        ],
        child: OverlaySupport.global(
            child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Toot',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.indigo,
              canvasColor: Colors.grey.shade50,
              toggleableActiveColor: Color(0xff7C39CB),
              fontFamily: 'Tajawal'),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/cart': (BuildContext context) => new CartScreen(),
          },
        )),
      ),
    );
  }
}
