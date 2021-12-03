import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/cubits/product_cubit/product_cubit.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/data/models/check_box_state.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';

import '../../constants.dart';
import 'cart_screen.dart';

class SingleItemScreen extends StatefulWidget {
  final int id;
  final String? title;
  final double? price;
  final int? shopId;
  final bool? isFav;
  final bool? isEditable;
  final bool? removeFav;
  bool? fromPanner;
  int? count;

  SingleItemScreen(
      {required this.id,
      this.title,
      this.price,
      this.shopId,
      this.isFav,
      this.removeFav = false,
      this.isEditable = false,
      this.fromPanner,
      this.count});

  @override
  _SingleItemScreenState createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  late bool isFav;
  int quantity = 1;
  // int? selectedId;
  String? dropdownPriceValue = '';
  // List prices = [];
  List extra = [];
  List chosenExtra = [];
  // final _formKey = GlobalKey<FormState>();
  List<String> images = [];
  double price = 0.00;
  int current = 0;
  bool isChanged = false;

  addExtrasPrice(double extraPrice1, bool incremental, int chosenId) {
    if (incremental) {
      setState(() {
        this.price = this.price + extraPrice1;
        isChanged = true;
      });
    } else {
      setState(() {
        this.price = this.price - extraPrice1;
      });
    }
    if (chosenExtra.contains(chosenId)) {
      chosenExtra.removeWhere((element) => element == chosenId);
      print(chosenExtra);
      return;
    }
    chosenExtra.add(chosenId);
  }

  removeCart() async {
    print(LocalStorage.getData(key: 'cart_token'));
    var response = await Dio().post('https://toot.work/api/cart/remove',
        data: {"cart_token": LocalStorage.getData(key: 'cart_token')},
        options: Options(headers: {
          "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
        }));
    print(response.data);
  }

  Future<bool> _showAnotherVendorDialog(int id, var optionId) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Center(
              child: const Text(
            'خطأ',
            style: TextStyle(color: Colors.red),
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('عذرا لا يمكنك الطلب من اكثر من فرع'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: const Text(
                'استكمال طلبك السابق',
                style: TextStyle(color: Color(0xff7C39CB)),
              ),
            ),
            TextButton(
              child: const Text(
                'الغاء طلبك',
                style: TextStyle(color: Color(0xff7C39CB)),
              ),
              onPressed: () async {
                setState(() {
                  LocalStorage.saveData(key: 'counter', value: 0);
                  LocalStorage.saveData(key: 'cart_token', value: '');
                  LocalStorage.saveData(key: 'vendor', value: widget.shopId);
                });
                await removeCart();

                BlocProvider.of<CartCubit>(context).addToCart(
                    shopId: widget.shopId,
                    productId: id,
                    quantity: quantity,
                    options: optionId,
                    extras: chosenExtra);

                Navigator.of(context1).pop(true);
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }

  @override
  void initState() {
    BlocProvider.of<ProductCubit>(context).fetchItemDetails(widget.id);
    price = widget.price!;
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    // BlocProvider.of<AuthCubit>(context).emit(AuthInitial());
    // Navigator.pop(context);
    if (widget.fromPanner != null)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title!,
          style: TextStyle(
              color: Color(Constants.mainColor), fontWeight: FontWeight.w300),
        ),
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Color(Constants.mainColor), size: 25),
          splashRadius: 25,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: _willPopCallback,
        child:
            BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
          if (state is ItemDetailsLoaded) {
            final item = state.itemDetails;

            if (item.options!.isNotEmpty) {
              dropdownPriceValue = item.options![0].price ?? '';
            }
            extra = state.itemDetails.addon!
                .map((extra) => CheckBoxState(
                    name: '${extra.nameAr}   + ${extra.price}  SR ',
                    price: double.parse(extra.price!),
                    id: extra.id!))
                .toList();

            if (item.imageOne != null) {
              images.add(item.imageOne!);
            }
            if (item.imageTwo != null) {
              images.add(item.imageTwo!);
            }
            if (item.imageThree != null) {
              images.add(item.imageThree!);
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  images.isNotEmpty
                      ? Center(
                          child: CarouselSlider.builder(
                            itemCount: images.length,
                            options: CarouselOptions(
                                height: 0.4.sh,
                                autoPlay: true,
                                viewportFraction: 0.9,
                                autoPlayInterval: Duration(seconds: 8),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    current = index;
                                  });
                                }),
                            itemBuilder: (ctx, index, _) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      images[index],
                                      fit: BoxFit.fitHeight,
                                      width: 0.9.sw,
                                    )),
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(15),
                          child: ClipRRect(
                              child: Image.asset(
                            'assets/images/00vv63.jpg',
                            fit: BoxFit.fill,
                            width: 0.8.sw,
                          )),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 0.03.sh, top: 0.05.sh),
                          child: Row(
                            mainAxisAlignment: price == 0.00
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  price == 0.00
                                      ? Text(
                                          'السعر يعتمد علي اختياراتك',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff4A4B4D)),
                                        )
                                      : Text(
                                          isChanged
                                              ? (price * quantity)
                                                      .toStringAsFixed(2) +
                                                  " SR "
                                              : (state.price! * quantity)
                                                      .toStringAsFixed(2) +
                                                  " SR ",
                                          style: TextStyle(
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff4A4B4D)),
                                        ),
                                  Visibility(
                                    visible: price != 0.00,
                                    child: item.unit.toString() != "null"
                                        ? Text(' لكل/ ${item.unit}',
                                            style: TextStyle(
                                              color: Color(0xff4A4B4D),
                                            ))
                                        : Text('لكل/ كيلو',
                                            style: TextStyle(
                                              color: Color(0xff4A4B4D),
                                            )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: item.options!.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              ' يمكنك اختيار [ 1 اختيار ] :',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff4A4B4D),
                                  fontSize: 18.sp),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: item.options!.isNotEmpty,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 0.06.sw, right: 0.02.sw),
                                  filled: true,
                                  fillColor: Color(0xffF0F4F8),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none)),
                              isExpanded: true,
                              value: state.optionId,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 28,
                                color: Color(Constants.mainColor),
                              ),
                              iconSize: 24,
                              elevation: 4,
                              style: TextStyle(
                                  color: Color(Constants.mainColor),
                                  fontSize: 16),
                              onChanged: (int? newValue) {
                                print(newValue.toString() + 'rkhbgfryuhgb');
                                setState(() {
                                  isChanged = true;
                                  state.optionId = newValue;
                                });
                                print(state.optionId);
                              },
                              items: item.options!
                                  .map<DropdownMenuItem<int>>((value) {
                                return DropdownMenuItem<int>(
                                  value: value.id,
                                  onTap: () {
                                    print(value.id.toString() + 'rkhbgfryuhgb');
                                    setState(() {
                                      price = double.parse(value.price!);
                                      state.optionId = value.id!;
                                    });
                                    print(state.optionId);
                                  },
                                  child: Text(
                                    '${value.textAr}  ${value.price} SR ',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: extra.isNotEmpty && item.options!.isNotEmpty,
                          child: SizedBox(
                            height: 0.05.sh,
                          ),
                        ),
                        Visibility(
                          visible: extra.isNotEmpty,
                          child: Text(
                            'يمكنك الاختيار من الاضافات :',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xff4A4B4D),
                                fontSize: 18.sp),
                          ),
                        ),
                        ...extra.map((e) => BuildCheckboxListTile(
                              checkBoxState: e,
                              function: addExtrasPrice,
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.03.sh),
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffF0F4F8),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    splashRadius: 1,
                                    icon: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Color(Constants.mainColor),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Color(Constants.mainColor),
                                    ),
                                  ),
                                  IconButton(
                                    splashRadius: 1,
                                    icon: Icon(
                                      Icons.remove,
                                      size: 24,
                                      color: Color(Constants.mainColor),
                                    ),
                                    onPressed: () {
                                      if (quantity == 1) {
                                        return;
                                      } else {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, cartState) {
                            return Container(
                              width: 1.sw,
                              height: 0.07.sh,
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(state.optionId);
                                    if (widget.count == 0) {
                                      showSimpleNotification(
                                          Container(
                                            height: 55,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                'عذرا هذا المنتج غير متوفر حاليا',
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          duration: Duration(seconds: 3),
                                          background: Colors.white);
                                    } else {
                                      if (widget.isEditable!) {
                                        BlocProvider.of<CartCubit>(context)
                                            .removeFromCart(
                                                productId:
                                                    state.itemDetails.id);
                                      }
                                      if (LocalStorage.getData(
                                              key: 'counter') ==
                                          0) {
                                        LocalStorage.saveData(
                                            key: 'vendor',
                                            value: widget.shopId);
                                      }
                                      if (LocalStorage.getData(key: 'vendor') ==
                                              null ||
                                          LocalStorage.getData(key: 'vendor') ==
                                              widget.shopId) {
                                        BlocProvider.of<CartCubit>(context)
                                            .addToCart(
                                                shopId: widget.shopId,
                                                productId: state.itemDetails.id,
                                                quantity: quantity,
                                                options: [state.optionId],
                                                extras: chosenExtra)
                                            .then((value) {
                                          if (widget.isEditable!)
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CartScreen()));
                                          else
                                            Navigator.pop(context, "added");
                                        });
                                      } else {
                                        _showAnotherVendorDialog(
                                                widget.id, [state.optionId])
                                            .then((value) {
                                          if (value)
                                            Navigator.pop(context,
                                                'addedAfterDeletingCart');
                                        });
                                      }
                                      // Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(Constants.mainColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: cartState is CartLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              widget.isEditable!
                                                  ? Icons.edit
                                                  : Icons.add_shopping_cart,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Text(widget.isEditable!
                                                ? 'تعديل'
                                                : 'اضافة الي السله')
                                          ],
                                        )),
                            );
                          },
                        ),
                        item.description.toString() != "null"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 25.0, bottom: 12),
                                child: Text(
                                  'الوصف',
                                  style: TextStyle(
                                      color: Color(Constants.mainColor),
                                      fontSize: 21.sp),
                                ),
                              )
                            : Container(),
                        item.description.toString() != "null"
                            ? Html(
                                data: item.description,
                                shrinkWrap: true,
                              )
                            : Container(),
                        SizedBox(
                          height: 0.1.sh,
                        ),
                      ],
                    ),
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
        }),
      ),
    );
  }
}

class BuildCheckboxListTile extends StatefulWidget {
  final CheckBoxState checkBoxState;
  final Function function;

  BuildCheckboxListTile({
    context,
    required this.checkBoxState,
    required this.function,
  });

  @override
  State<BuildCheckboxListTile> createState() => _BuildCheckboxListTileState();
}

class _BuildCheckboxListTileState extends State<BuildCheckboxListTile> {
  bool isAdded = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(
          widget.checkBoxState.name,
          style: TextStyle(fontSize: 16.sp, color: Color(Constants.mainColor)),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: isAdded,
        onChanged: (value) {
          setState(() {
            isAdded = value!;
            print(isAdded);
            if (isAdded == true) {
              return widget.function(
                  widget.checkBoxState.price, true, widget.checkBoxState.id);
            } else {
              return widget.function(
                  widget.checkBoxState.price, false, widget.checkBoxState.id);
            }
          });
        });
  }
}
