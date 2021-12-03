import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/presentation/screens/order_summary_screen.dart';
import 'package:toot/presentation/widgets/default_indigo_button.dart';
import 'package:toot/presentation/widgets/delivery_app_bar.dart';
import 'package:toot/presentation/widgets/single_choice_delivery.dart';

class DeliveryOptionsScreen extends StatefulWidget {
  final int id;
  String? delivery;
  DeliveryOptionsScreen({required this.id, this.delivery});
  @override
  _DeliveryOptionsScreenState createState() => _DeliveryOptionsScreenState();
}

class _DeliveryOptionsScreenState extends State<DeliveryOptionsScreen> {
  List<bool> deliverySelections = List<bool>.filled(2, false, growable: false);
  List<bool> dateSelections = List<bool>.filled(7, false, growable: false);
  List<bool> timeSelections = List<bool>.filled(20, false, growable: false);
  bool isExpanded = false;

  int? id;
  String? date;

  List<bool> singleSelection(List<bool> selections, bool selection, int index) {
    if (selections.contains(true)) {
      int i = selections.indexOf(true);
      selections[i] = false;
      selections[index] = true;
    } else {
      selections[index] = selection;
    }
    print(selections);
    return selections;
  }

  @override
  void initState() {
    print(widget.delivery);
    BlocProvider.of<CartCubit>(context).fetchDatesAndTimes(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildDeliveryBar(
        title: 'خيارات التوصيل',
        isDelivery: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is InfoLoaded) {
            final info = state.info;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    Text(
                      'موعد التوصيل',
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w100),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChoiceDelivery(
                          selectionFunction: singleSelection,
                          choicesList: deliverySelections,
                          index: 0,
                          function: () {
                            setState(() {
                              isExpanded = false;
                            });
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "التوصيل السريع ( 5-60 دقيقة )",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18.sp),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              widget.delivery.toString() != 'null'
                                  ? Text(
                                      "يضاف ${widget.delivery} ريال على التوصيل المباشر",
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "يضاف 4 ريال على التوصيل المباشر",
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                        ),
                        SingleChoiceDelivery(
                          selectionFunction: singleSelection,
                          choicesList: deliverySelections,
                          function: () {
                            setState(() {
                              isExpanded = true;
                            });
                          },
                          index: 1,
                          title: Text(
                            "توصيل لاحقا",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 18.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    !isExpanded
                        ? SizedBox(
                            height: 0.3.sh,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                                child: Text(
                                  'اختيار التاريخ',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.grey.shade500),
                                ),
                              ),
                              Container(
                                height: 0.06.sh,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: info.dates!
                                      .map((e) => BuildDayItem(
                                            day: DateFormat('dd-MM-yyyy')
                                                .format(e),
                                            index: info.dates!.indexOf(e),
                                            choicesList: dateSelections,
                                            selectionFunction: singleSelection,
                                            function: () {
                                              setState(() {
                                                date = DateFormat('yyyy-MM-dd')
                                                    .format(e);
                                              });
                                            },
                                          ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height: 0.02.sh,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 10),
                                child: Text(
                                  'اختيار الوقت',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.grey.shade500),
                                ),
                              ),
                              Container(
                                height: 0.06.sh,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: info.times!
                                      .map((e) => BuildDayItem(
                                            day: e.duration!,
                                            selectionFunction: singleSelection,
                                            choicesList: timeSelections,
                                            index: info.times!.indexOf(e),
                                            function: () {
                                              setState(() {
                                                id = e.id;
                                              });
                                            },
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.05.sh),
                      child: BuildIndigoButton(
                          title: 'استمرار',
                          function: () {
                            if (deliverySelections[0]) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) => OrderSummaryScreen()))
                                  .then((value) =>
                                      BlocProvider.of<CartCubit>(context)
                                          .emit(InfoLoaded(info: info)));
                            } else if (deliverySelections[1] &&
                                dateSelections.contains(true) &&
                                timeSelections.contains(true)) {
                              BlocProvider.of<CartCubit>(context)
                                  .confirmInfoDateAndTime(date: date, id: id);

                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) => OrderSummaryScreen(
                                          delivery: widget.delivery)))
                                  .then((value) =>
                                      BlocProvider.of<CartCubit>(context)
                                          .emit(InfoLoaded(info: info)));
                            } else
                              showSimpleNotification(
                                  Container(
                                    height: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'من فضلك اختر وقت التوصيل المناسب لك',
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                  background: Colors.white);
                          }),
                    )
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
    );
  }
}

class BuildDayItem extends StatelessWidget {
  final String day;
  final Function selectionFunction;
  final Function function;
  final List<bool> choicesList;
  final int index;
  BuildDayItem(
      {required this.day,
      required this.selectionFunction,
      required this.choicesList,
      required this.index,
      required this.function});

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            function();
            return selectionFunction(choicesList, isSelected, index);
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 0.24.sw,
          decoration: BoxDecoration(
              color: choicesList[index] == true
                  ? Colors.green[400]
                  : Color(0xffF0F4F8),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Text(
            day,
            style: TextStyle(
                fontSize: 16.sp,
                color: choicesList[index] == true
                    ? Colors.white
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w300),
          )),
        ),
      ),
    );
  }
}
