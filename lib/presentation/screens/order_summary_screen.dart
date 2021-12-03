import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/presentation/screens/telr-web_view.dart';
import 'package:toot/presentation/widgets/cart_item.dart';
import 'package:toot/presentation/widgets/delivery_app_bar.dart';
import 'package:toot/presentation/widgets/discount_modal_bottom_sheet.dart';

import '../../constants.dart';
import 'order_confirmation.dart';

class OrderSummaryScreen extends StatefulWidget {
  String? delivery;
  OrderSummaryScreen({this.delivery});
  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  List<bool> selections = List<bool>.filled(2, false, growable: false);
  String selectionMethod = '';
  bool done = false;
  String? url;

  @override
  void initState() {
    print(widget.delivery);
    BlocProvider.of<CartCubit>(context).fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: BuildDeliveryBar(
        title: 'ملخص الطلب',
        isSummary: true,
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (_, state) {
          if (state is OrderConfirmed) {
            final num = state.num;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => OrderConfirmationScreen(
                          num: num,
                        )),
                (Route route) => false);
          }
          if (state is PaymentAdded) {
            setState(() {
              url = state.url;
            });
            if (url != '') {
              print(url);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelrWebView(
                            url: url,
                          ))).then((value) {});
              BlocProvider.of<CartCubit>(context).fetchCart();
            } else
              BlocProvider.of<CartCubit>(context).confirmOrder();
          }
        },
        builder: (_, state) {
          if (state is CartLoaded) {
            final cartDetails = state.cartDetails;
            final paymentsMethods = state.payments;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 0.06.sw, left: 0.06.sw, top: 0.02.sh),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartDetails.data!.items!.length,
                      itemBuilder: (context, index) => CartItem(
                        title: cartDetails.data!.items![index].productName,
                        image: cartDetails.data!.items![index].productImage,
                        price: cartDetails.data!.items![index].total.toString(),
                        quantity: cartDetails.data!.items![index].count,
                        id: cartDetails.data!.items![index].productId,
                        shopId: cartDetails.data!.items![index].vendorId,
                        addons: cartDetails.data!.items![index].cartitemaddon!,
                        extra: cartDetails.data!.items![index].cartitemoption!,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              itemCount: 2,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    setState(() {
                                      selections = [false, false];
                                      selections[index] = !selections[index];
                                      selectionMethod =
                                          paymentsMethods![index].code;
                                    });

                                    BlocProvider.of<CartCubit>(context)
                                        .selectPayment(method: selectionMethod);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 7),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: !selections[index]
                                                ? Colors.black38
                                                : Color(Constants.mainColor),
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 0.1.sw,
                                          width: 0.1.sw,
                                          child: Image.network(
                                            paymentsMethods![index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          paymentsMethods[index].titleAr,
                                          style: TextStyle(
                                            color: selections[index]
                                                ? Color(Constants.mainColor)
                                                : Colors.grey.shade600,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Spacer(),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: selections[index]
                                              ? Icon(
                                                  FontAwesomeIcons
                                                      .solidCheckCircle,
                                                  size: 25.0,
                                                  color: Color(
                                                      Constants.mainColor),
                                                )
                                              : Icon(
                                                  FontAwesomeIcons.solidCircle,
                                                  size: 25.0,
                                                  color: Colors.grey.shade300,
                                                ),
                                        )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    cartDetails.data!.discount.toString() != "null"
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('احصل علي خصم مع طلبك'),
                                Container(
                                  width: 0.35.sw,
                                  height: 0.042.sh,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        discountModalBottomSheetMenu(context),
                                    child: Text(
                                      'اضافة رمز ترويجي',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(Constants.mainColor)),
                                  ),
                                )
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'قيمة المنتجات',
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.blueGrey.shade400),
                          ),
                          Text('SR ${cartDetails.data!.subTotal}',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.blueGrey.shade400,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الضريبة',
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.blueGrey.shade400),
                          ),
                          Text('SR ${cartDetails.data!.tax}',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.blueGrey.shade400,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'التوصيل',
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.blueGrey.shade400),
                          ),
                          widget.delivery.toString() == "null"
                              ? Text('SR ${cartDetails.data!.deliveryFee}',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.blueGrey.shade400,
                                      fontWeight: FontWeight.w600))
                              : Text(
                                  'SR ${int.parse(cartDetails.data!.deliveryFee!) - int.parse(widget.delivery!)}',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.blueGrey.shade400,
                                      fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    cartDetails.data!.discount.toString() == "null"
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'كوبون الخصم/نقاط الخصم',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.blueGrey.shade400),
                                ),
                                Text('SR ${cartDetails.data!.discount}',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.blueGrey.shade400,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المجموع',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(Constants.mainColor),
                            ),
                          ),
                          Text('SR ${cartDetails.data!.total}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(Constants.mainColor),
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),

                    Container(
                      height: 0.06.sh,
                      width: 0.85.sw,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(Constants.mainColor)),
                      child: InkWell(
                        onTap: () {
                          print(selectionMethod);
                          if (int.parse(cartDetails.data!.deliveryFee!) != 0) {
                            if (selectionMethod == '')
                              showSimpleNotification(
                                  Container(
                                    height: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'من فضلك اختر طريقة الدفع المناسبة لك',
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                  background: Colors.white);
                            else
                              BlocProvider.of<CartCubit>(context)
                                  .confirmOrder(method: selectionMethod);
                          } else
                            showSimpleNotification(
                                Container(
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'عذرا موقعك خارج نطاق توصيل مقدم الخدمة',
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'تأكيد الطلب',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // BuildIndigoButton(
                    //     title: 'تأكيد الطلب',
                    //     function: () {
                    //       if (selectionMethod != '') {
                    //         if (selectionMethod == 'card')
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => AddVisaScreen()));
                    //         else
                    //           BlocProvider.of<CartCubit>(context)
                    //               .selectPayment(method: selectionMethod)
                    //               .then((value) =>
                    //                   BlocProvider.of<CartCubit>(context)
                    //                       .confirmOrder());
                    //       } else
                    //         showSimpleNotification(
                    //             Container(
                    //               height: 55,
                    //               child: Padding(
                    //                 padding: const EdgeInsets.only(top: 8.0),
                    //                 child: Text(
                    //                   'من فضلك اختر طريقة الدفع المناسبة لك',
                    //                   style: TextStyle(
                    //                       color: Colors.indigo,
                    //                       fontSize: 18,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ),
                    //             ),
                    //             duration: Duration(seconds: 3),
                    //             background: Colors.white);
                    //     }
                    //     // }
                    //     ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                  ],
                ),
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
        },
      ),
    );
  }

  // displayToastMessage(var toastMessage) {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Center(
  //           child: const Text(
  //             'عفوا',
  //             style: TextStyle(color: Colors.red),
  //           ),
  //         ),
  //         content: Text(
  //           toastMessage,
  //           textAlign: TextAlign.center,
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text(
  //               'حسنا',
  //               style: TextStyle(color: Color(0xff7C39CB)),
  //             ),
  //             onPressed: () {
  //               Navigator.pushReplacement(context,
  //                   MaterialPageRoute(builder: (context) => BottomNavBar()));
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
