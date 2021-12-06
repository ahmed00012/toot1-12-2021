import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:toot/cubits/auth_cubit/auth_cubit.dart';
import 'package:toot/presentation/screens/reset_password.dart';
import 'package:toot/presentation/widgets/blurry_dialog.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';

import '../../constants.dart';

class ActivateAccountScreen extends StatefulWidget {
  final String? phone;
  final String? password;
  final String? name;
  final String? email;
  final String? identityNumber;

  ActivateAccountScreen(
      {required this.phone,
      this.email,
      this.password,
      this.name,
      this.identityNumber});

  @override
  State<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  var counter = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

  _showDialog(BuildContext context, String title) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
        };

    BlurryDialog alert = BlurryDialog('خطأ', title, continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> _willPopCallback() async {
    BlocProvider.of<AuthCubit>(context).emit(AuthInitial());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'تأكيد رقم الهاتف',
            style: TextStyle(color: Color(Constants.mainColor)),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          toolbarHeight: 90,
          leading: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(Constants.mainColor),
                ),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (BuildContext context, state) {
            if (state is OtpSuccess) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            } else if (state is VerifyForgetPasswordSuccess) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPassword(
                            phone: widget.phone,
                          )));
            } else if (state is AuthError) {
              _showDialog(context, state.error);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 0.2.sh,
                    ),
                    Text(
                      'لقد تم ارسال رمز الي الهاتف الخاص بك',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Color(Constants.mainColor),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.08.sh),
                      child: FaIcon(
                        FontAwesomeIcons.envelopeOpenText,
                        color: Color(Constants.mainColor),
                        size: 100,
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Color(Constants.mainColor),
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          textStyle: TextStyle(
                              color: Color(Constants.mainColor),
                              fontSize: 25.sp),
                          // obscureText: true,
                          // obscuringCharacter: '*',
                          obscuringWidget: Center(
                            child: Icon(
                              FontAwesomeIcons.starOfLife,
                              color: Color(Constants.mainColor),
                            ),
                          ),
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(6),
                            fieldHeight: 55.w,
                            fieldWidth: 55.w,
                            activeColor: Colors.indigo.shade400,
                            inactiveColor: Colors.indigo.shade500,
                            selectedColor: Colors.indigo.shade500,
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            activeFillColor: Colors.white,
                          ),
                          cursorColor: Color(Constants.mainColor),
                          animationDuration: Duration(milliseconds: 200),
                          enableActiveFill: true,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              color: Colors.black12,
                              blurRadius: 3,
                            )
                          ],

                          onCompleted: (v) async {
                            if (widget.name == null) {
                              await BlocProvider.of<AuthCubit>(context)
                                  .verifyForgetPassword(
                                      otp: v, phone: widget.phone);
                            } else
                              await BlocProvider.of<AuthCubit>(context).otp(
                                  otp: v,
                                  phone: widget.phone,
                                  name: widget.name,
                                  email: widget.email,
                                  password: widget.password);
                          },
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    CountdownTimer(
                      endTime: counter,
                      widgetBuilder: (context, time) {
                        return time != null
                            ? Text(
                                'لارسال الكود مرة اخرى برجاء الانتظار :  ${time.sec} ثانية',
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold),
                              )
                            : InkWell(
                                onTap: () {
                                  if (widget.name == null) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .forgetPassword(phone: widget.phone);
                                  } else
                                    BlocProvider.of<AuthCubit>(context)
                                        .register(
                                            name: widget.name,
                                            phone: widget.phone,
                                            identityNo: widget.identityNumber,
                                            password: widget.password,
                                            confirmPassword: widget.password);

                                  setState(() {
                                    counter =
                                        DateTime.now().millisecondsSinceEpoch +
                                            1000 * 60;
                                  });
                                },
                                child: Text('ارسال الكود مرة اخرى ',
                                    style: TextStyle(
                                        color: Color(Constants.mainColor),
                                        fontWeight: FontWeight.bold)),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
