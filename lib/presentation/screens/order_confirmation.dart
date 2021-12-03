import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toot/presentation/screens/orders_details_screen.dart';
import 'package:toot/presentation/screens/orders_screen.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';
import 'package:toot/presentation/widgets/indigo_elevated_button.dart';

import '../../constants.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final int? num;
  OrderConfirmationScreen({this.num});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          height: 1.sh,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/graphic-confirmation.png',
                  height: 0.45.sw,
                  width: 0.45.sw,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 0.07.sh,
                ),
                Text(
                  ' تم ارسال طلبك بنجاح',
                  style:
                      TextStyle(fontSize: 24.sp, color: Colors.grey.shade600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => OrdersDetailsScreen(
                              id: num!,
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'رقم الطلب # ' + num.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(Constants.mainColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BuildElevatedButton(
                      title: 'حالة الطلب',
                      function: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => OrdersDetailsScreen(
                                  id: num!,
                                )));
                      },
                    ),
                    BuildElevatedButton(
                      title: 'طلباتي',
                      function: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => OrdersScreen()));
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: BuildElevatedButton(
                    title: 'الشاشة الرئيسية',
                    function: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => BottomNavBar()),
                          (Route route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
