import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';
import 'package:toot/presentation/widgets/indigo_elevated_button.dart';

import 'orders_screen.dart';

class OrdersDetailsScreen extends StatefulWidget {
  final int id;

  OrdersDetailsScreen({required this.id});

  @override
  _OrdersDetailsScreenState createState() => _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen> {
  @override
  void initState() {
    BlocProvider.of<CartCubit>(context).fetchOrderStatus(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BuildAppBar(
          title: 'حالة الطلب',
          isBack: false,
        ),
        bottomSheet: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.025.sh),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BuildElevatedButton(
                  title: 'تحديث',
                  function: () {
                    BlocProvider.of<CartCubit>(context)
                        .fetchOrderStatus(widget.id);
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
          ),
        ),
        body: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
          if (state is OrderStatusLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
              child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                      child: Image.asset(
                    'assets/images/order status.gif',
                    height: 0.26.sh,
                    fit: BoxFit.fill,
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      state.order.expectedTime.toString() != "null"
                          ? Text(
                              'الوقت المتوقع لاستلام الطلب : ' +
                                  state.order.expectedTime.toString() +
                                  ' ' +
                                  'دقيقة',
                              style: TextStyle(fontSize: 16),
                            )
                          : Container(),
                      Text(
                        'رقم الطلب' + ' ' + widget.id.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: state.order.statusHistories!.length,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(
                                20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 2,
                                  ),
                                  Container(
                                    width: 50,
                                    child: Image.network(
                                      '${state.order.statusHistories![index].status!.image}',
                                      fit: BoxFit.contain,
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${state.order.statusHistories![index].status!.name}",
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "${state.order.statusHistories![index].status!.createdAt}",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  )
                ],
              ),
            );
          } else
            return Center(
                child: Container(
              height: 120,
              width: 120,
              child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
            ));
        }));
  }
}
