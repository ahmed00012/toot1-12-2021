import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/data/models/last_order.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';

import 'orders_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CartCubit>(context).fetchLastOrders();
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: BuildAppBar(
          title: 'طلباتك',
          isBack: false,
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is LastOrdersLoaded) {
              final orders = state.orders;
              if (orders.isEmpty)
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Center(
                      child: Container(
                        height: 220,
                        width: 220,
                        child: Lottie.asset('assets/images/lf20_gsfn6jrs.json'),
                      ),
                    ),
                    Text('قائمة طلباتك فارغة قم بالطلب الان ')
                  ],
                );
              else
                return ListView.builder(
                    itemCount: orders.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) => OrderItem(
                          id: orders[index].id!,
                          cart: orders[index].cart!,
                          cartStatus: orders[index].status!.name!,
                          function: () async {
                            setState(() {});
                          },
                        ));
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
      ),
    );
  }
}

class OrderItem extends StatefulWidget {
  final int id;
  final Cart cart;
  final String cartStatus;
  final Function function;

  OrderItem(
      {required this.id,
      required this.cart,
      required this.function,
      required this.cartStatus});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExtended = !isExtended;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.02.sh, horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.03.sh),
        width: 0.95.sw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Color(0xffF0F4F8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' طلب #${widget.id}',
                    style:
                        TextStyle(fontSize: 18.sp, color: Colors.grey.shade600),
                  ),
                  Icon(
                      isExtended
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                      color: Colors.grey.shade600)
                ],
              ),
              isExtended
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => OrdersDetailsScreen(
                              id: widget.id,
                            ),
                          ),
                        )
                            .then((value) {
                          return widget.function();
                        });
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ...widget.cart.items!
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.productName ?? '',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${e.price}' + ' SR',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          Divider(),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'قيمة التوصيل',
                                      style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Text(
                                    '${widget.cart.deliveryFee}' + ' SR',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'الاجمالي',
                                      style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Text(
                                    '${widget.cart.total}' + ' SR',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    'حالة الطلب',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade400),
                                  )),
                                  Text(
                                    widget.cartStatus,
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // Container(
                                  //   height: 25,
                                  //   width: 25,
                                  //   decoration: BoxDecoration(
                                  //       shape: BoxShape.circle,
                                  //       color: Color(Constants.mainColor)),
                                  //   child: Icon(
                                  //     Icons.check,
                                  //     color: Colors.white,
                                  //     size: 20,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
