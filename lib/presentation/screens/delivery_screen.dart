import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/presentation/screens/add_delivery_screen.dart';
import 'package:toot/presentation/widgets/default_indigo_button.dart';
import 'package:toot/presentation/widgets/delivery_app_bar.dart';
import 'package:toot/presentation/widgets/single_choice_item.dart';

import 'cart_screen.dart';
import 'delivery_options_screen.dart';

class DeliveryAddressesScreen extends StatefulWidget {
  final int id;
  bool? added;
  String? delivery;
  DeliveryAddressesScreen({required this.id, this.added, this.delivery});
  @override
  _DeliveryAddressesScreenState createState() =>
      _DeliveryAddressesScreenState();
}

class _DeliveryAddressesScreenState extends State<DeliveryAddressesScreen> {
  List<bool> selections = List<bool>.filled(30, false, growable: false);
  int? id;
  List savedAddress = [];
  String? token;

  List<bool> singleSelection(bool selection, int index, int id) {
    setState(() {
      this.id = id;
    });
    if (selections.contains(true)) {
      int i = selections.indexOf(true);
      selections[i] = false;
      selections[index] = true;
    } else {
      selections[index] = selection;
    }
    setState(() {});
    return selections;
  }

  @override
  void initState() {
    BlocProvider.of<CartCubit>(context).fetchAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.added != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
        } else
          Navigator.pop(context);

        return Future.value(true);
      },
      child: Scaffold(
        appBar: BuildDeliveryBar(
          title: 'عناوين التوصيل',
          isLocation: true,
        ),
        bottomSheet: Container(
          height: 0.2.sh,
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (_) => AddDeliveryScreen(widget.id)))
                      .then((value) {
                    BlocProvider.of<CartCubit>(context).fetchAddress();
                    setState(() {});
                  });
                },
                child: Container(
                  height: 0.065.sh,
                  width: 0.5.sw,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('إضافة عنوان جديد'),
                    ],
                  ),
                ),
              ),
              BuildIndigoButton(
                  title: 'استمرار',
                  function: () {
                    if (selections.contains(true)) {
                      BlocProvider.of<CartCubit>(context)
                          .selectAddress(addressId: id);
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (_) => DeliveryOptionsScreen(
                                    id: widget.id,
                                    delivery: widget.delivery,
                                  )))
                          .then((value) => BlocProvider.of<CartCubit>(context)
                              .emit(AddressesLoaded(addresses: savedAddress)));
                    } else
                      showSimpleNotification(
                          Container(
                            height: 55,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'من فضلك اختر عنوان حتى نستطيع توصيل الطلب اليك',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          duration: Duration(seconds: 3),
                          background: Colors.white);
                  })
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              right: 0.04.sw, left: 0.04.sw, top: 0.03.sw, bottom: 0.2.sh),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is AddressesLoaded) {
                final addresses = state.addresses;
                savedAddress = addresses;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  // physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) => SingleChoiceItem(
                      function: singleSelection,
                      choicesList: selections,
                      index: index,
                      subtitle: addresses[index].district.toString(),
                      title: addresses[index].address!,
                      id: addresses[index].id),
                );
              } else {
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
              }
            },
          ),
        ),
      ),
    );
  }
}
