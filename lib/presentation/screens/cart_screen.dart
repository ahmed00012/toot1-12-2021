import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/presentation/widgets/blurry_dialog.dart';
import 'package:toot/presentation/widgets/cart_item.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';
import 'package:toot/presentation/widgets/default_indigo_button.dart';

import '../../constants.dart';
import 'auth_screen.dart';
import 'delivery_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
  void initState() {
    BlocProvider.of<CartCubit>(context).fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        title: 'السله',
        isBack: false,
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              final cartDetails = state.cartDetails;
              return Padding(
                padding: EdgeInsets.only(
                    right: 0.06.sw, left: 0.06.sw, top: 0.02.sh),
                child: Column(
                  children: [
                    Container(
                      height: 0.46.sh,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: cartDetails.data!.items!.length,
                          itemBuilder: (context, index) {
                            if (cartDetails
                                .data!.items![0].cartitemaddon!.isNotEmpty)
                              cartDetails.data!.items![index].cartitemaddon!
                                  .removeWhere((element) =>
                                      element.addon!.nameAr == null);
                            return CartItem(
                              title:
                                  cartDetails.data!.items![index].productName,
                              image:
                                  cartDetails.data!.items![index].productImage,
                              price: cartDetails.data!.items![index].total
                                  .toString(),
                              quantity: cartDetails.data!.items![index].count,
                              id: cartDetails.data!.items![index].productId,
                              shopId: cartDetails.data!.items![index].vendorId,
                              addons: cartDetails.data!.items![index]
                                      .cartitemaddon!.isNotEmpty
                                  ? cartDetails
                                      .data!.items![index].cartitemaddon
                                  : [],
                              extra: cartDetails
                                          .data!.items![index].cartitemoption !=
                                      []
                                  ? cartDetails
                                      .data!.items![index].cartitemoption
                                  : [],
                              function: () {
                                BlocProvider.of<CartCubit>(context)
                                    .emit(CartLoaded(cartDetails: cartDetails));
                              },
                              lastItem: cartDetails.data!.items!.length == 1
                                  ? true
                                  : false,
                            );
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "قيمة المنتجات",
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
                          Text('SR ${cartDetails.data!.tax.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.blueGrey.shade400,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 3.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'التوصيل',
                    //         style: TextStyle(
                    //             fontSize: 16.sp, color: Colors.blueGrey.shade400),
                    //       ),
                    //       Text('SR ${cartDetails.data!.deliveryFee}',
                    //           style: TextStyle(
                    //               fontSize: 16.sp,
                    //               color: Colors.blueGrey.shade400,
                    //               fontWeight: FontWeight.w600))
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المجموع',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(Constants.mainColor),
                            ),
                          ),
                          Text('SR ${cartDetails.data!.total}',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Color(Constants.mainColor),
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    BuildIndigoButton(
                        title: 'استكمال الطلب',
                        function: () async {
                          if (LocalStorage.getData(key: 'token') == null) {
                            _showDialog(context,
                                'حتي تتمكن من اتمام الطلب يجب عليك التسجيل اولا');
                          } else {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => DeliveryAddressesScreen(
                                          id: cartDetails
                                              .data!.items![0].vendorId!,
                                          delivery: state
                                              .cartDetails.data!.fastDelivery,
                                        )))
                                .then(
                                  (value) =>
                                      BlocProvider.of<CartCubit>(context).emit(
                                    CartLoaded(cartDetails: cartDetails),
                                  ),
                                );
                          }
                        }),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                  ],
                ),
              );
            } else if (state is CartLoading) {
              return Center(
                  child: Container(
                height: 120,
                width: 120,
                child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
              ));
              // return AlertDialog(
              //   backgroundColor: Colors.transparent,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15)),
              //   elevation: 0,
              //   content: Center(
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(15),
              //       child: Image.asset(
              //         'assets/images/loading.gif',
              //         height: 0.4.sw,
              //         width: 0.4.sw,
              //       ),
              //     ),
              //   ),
              // );
            } else {
              return Center(
                child: Column(
                  children: [
                    Lottie.asset('assets/images/lf20_feqy40fb.json',
                        height: 500),
                    Text(
                      'السلة فارغة',
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
