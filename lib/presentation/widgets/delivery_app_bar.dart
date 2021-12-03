import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class BuildDeliveryBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool? isLocation;
  final bool? isDelivery;
  // final bool? isPayment;
  final bool? isSummary;

  BuildDeliveryBar({
    required this.title,
    this.isDelivery = false,
    this.isLocation = false,
    // this.isPayment = false,
    this.isSummary = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(0.18.sh);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Color(Constants.mainColor),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
      bottom: PreferredSize(
          child: Container(
            height: 0.1.sh,
            decoration: BoxDecoration(
              color: Color(Constants.mainColor),
              // borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.ltr,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 0.5, color: Colors.white),
                      color: isSummary!
                          ? Colors.grey.shade200
                          : Colors.transparent),
                  child: Icon(
                    FontAwesomeIcons.list,
                    color: isSummary!
                        ? Color(Constants.mainColor)
                        : Colors.grey.shade200,
                    size: 20,
                  ),
                ),
                Text(
                  '.........',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border: Border.all(width: 0.5, color: Colors.white),
                //       color: isPayment!
                //           ? Colors.grey.shade200
                //           : Colors.transparent),
                //   child: Icon(
                //     FontAwesomeIcons.creditCard,
                //     color: isPayment!
                //         ? Color(Constants.mainColor)
                //         : Colors.grey.shade200,
                //     size: 20,
                //   ),
                // ),
                // Text(
                //   '.........',
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16.sp,
                //       fontWeight: FontWeight.w800),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 0.5, color: Colors.white),
                      color: isDelivery!
                          ? Colors.grey.shade200
                          : Colors.transparent),
                  child: Icon(
                    FontAwesomeIcons.truckLoading,
                    color: isDelivery!
                        ? Color(Constants.mainColor)
                        : Colors.grey.shade200,
                    size: 20,
                  ),
                ),
                Text(
                  '.........',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 0.5, color: Colors.white),
                      color: isLocation!
                          ? Colors.grey.shade200
                          : Colors.transparent),
                  child: Icon(
                    FontAwesomeIcons.mapMarkerAlt,
                    color: isLocation!
                        ? Color(Constants.mainColor)
                        : Colors.grey.shade200,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(0.1.sh)),
    );
  }
}
