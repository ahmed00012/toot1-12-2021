import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';

import '../../constants.dart';

void discountModalBottomSheetMenu(context) {
  TextEditingController textEditingController = TextEditingController();

  _showDialog(BuildContext context, BuildContext builder, String title) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: const Text(
              'حالة كوبون الخصم',
              style: TextStyle(color: Colors.green),
            ),
          ),
          content: Text(
            title,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'حسنا',
                style: TextStyle(color: Color(0xff7C39CB)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(builder).pop();
                BlocProvider.of<CartCubit>(context).fetchCart();
              },
            ),
          ],
        );
      },
    );
  }

  // _showDialog(BuildContext context, BuildContext builder, String title) {
  //   VoidCallback continueCallBack = () {
  //     Navigator.of(context).pop();
  //     Navigator.of(builder).pop();
  //     BlocProvider.of<CartCubit>(context).fetchCart();
  //   };
  //   BlurryDialog alert =
  //       BlurryDialog('حالة كوبون الخصم', title, continueCallBack,);
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0)),
      ),
      builder: (builder) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.only(top: 0.02.sh, left: 12, right: 12),
              height: 0.4.sh,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 0.25.sw,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.04.sh),
                    child: Text('استخدم قسمية الشراء',
                        style: TextStyle(fontSize: 20.sp)),
                  ),
                  TextField(
                    style: TextStyle(fontSize: 20.sp),
                    controller: textEditingController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Color(0xffF0F4F8),
                      hintText: 'اضافة رمز ترويجي',
                      prefixIcon: Icon(
                        FontAwesomeIcons.gift,
                        size: 25,
                        color: Color(Constants.mainColor),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 16.sp, color: Color(Constants.mainColor)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  SizedBox(
                    width: 1.sw,
                    height: 0.07.sh,
                    child: BlocListener<CartCubit, CartState>(
                      listener: (_, state) {
                        if (state is PromoLoaded) {
                          _showDialog(context, builder, state.promo.message);
                        } else if (state is CartError) {
                          _showDialog(context, builder, state.error);
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () async {
                          BlocProvider.of<CartCubit>(context)
                              .promoCode(code: textEditingController.text);
                        },
                        child: Text('استخدام الرمز'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(Constants.mainColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
