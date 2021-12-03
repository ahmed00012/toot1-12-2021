// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
// import 'package:toot/presentation/widgets/default_indigo_button.dart';
// import 'package:toot/presentation/widgets/delivery_app_bar.dart';
// import 'package:toot/presentation/widgets/single_choice_payment.dart';
//
// import 'order_summary_screen.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   List<bool> selections = List<bool>.filled(2, false, growable: false);
//   String? selectionMethod;
//   List<bool> singleSelection(bool selection, int index, String method) {
//     setState(() {
//       selectionMethod = method;
//     });
//     if (selections.contains(true)) {
//       int i = selections.indexOf(true);
//       selections[i] = false;
//       selections[index] = true;
//     } else {
//       selections[index] = selection;
//     }
//     setState(() {});
//     print(selections);
//     return selections;
//   }
//
//   @override
//   void initState() {
//     BlocProvider.of<CartCubit>(context).fetchPayments();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BuildDeliveryBar(
//         title: 'طريقة الدفع',
//         // isPayment: true,
//       ),
//       body: BlocBuilder<CartCubit, CartState>(
//         builder: (context, state) {
//           if (state is PaymentsLoaded) {
//             final paymentsMethods = state.payments;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SingleChoicePayment(
//                       function: singleSelection,
//                       choicesList: selections,
//                       index: 0,
//                       title: paymentsMethods[0].titleAr!,
//                       image: paymentsMethods[0].image!,
//                       isVisa: false,
//                       method: paymentsMethods[0].code!,
//                     ),
//                     SingleChoicePayment(
//                       function: singleSelection,
//                       choicesList: selections,
//                       index: 1,
//                       title: paymentsMethods[1].titleAr!,
//                       image: paymentsMethods[1].image!,
//                       isVisa: true,
//                       method: paymentsMethods[1].code!,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 0.45.sh,
//                 ),
//                 BuildIndigoButton(
//                     title: 'الاستمرار',
//                     function: () {
//                       print(selectionMethod);
//
//                       if (selections.contains(true)) {
//                         BlocProvider.of<CartCubit>(context)
//                             .selectPayment(method: selectionMethod);
//                         Navigator.of(context)
//                             .push(
//                               MaterialPageRoute(
//                                 builder: (_) => OrderSummaryScreen(),
//                               ),
//                             )
//                             .then((value) => BlocProvider.of<CartCubit>(context)
//                                 .emit(
//                                     PaymentsLoaded(payments: paymentsMethods)));
//                       } else
//                         showSimpleNotification(
//                             Container(
//                               height: 55,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Text(
//                                   'من فضلك اختر طريقة الدفع المناسبة لك',
//                                   style: TextStyle(
//                                       color: Colors.indigo,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                             duration: Duration(seconds: 3),
//                             background: Colors.white);
//                     })
//               ],
//             );
//           } else {
//             return Center(
//                 child: Container(
//               height: 120,
//               width: 120,
//               child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
//             ));
//             // return AlertDialog(
//             //   backgroundColor: Colors.transparent,
//             //   shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(15)),
//             //   elevation: 0,
//             //   content: Center(
//             //     child: ClipRRect(
//             //       borderRadius: BorderRadius.circular(15),
//             //       child: Image.asset(
//             //         'assets/images/loading.gif',
//             //         height: 0.4.sw,
//             //         width: 0.4.sw,
//             //       ),
//             //     ),
//             //   ),
//             // );
//           }
//         },
//       ),
//     );
//   }
// }
