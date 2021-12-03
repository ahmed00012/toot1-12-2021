import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toot/cubits/auth_cubit/auth_cubit.dart';
import 'package:toot/presentation/widgets/blurry_dialog.dart';

import '../../constants.dart';
import 'auth_screen.dart';

class ResetPassword extends StatefulWidget {
  String? phone;
  ResetPassword({this.phone});
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool seePassword = false;

  bool seePassword1 = false;

  TextEditingController password = TextEditingController();

  TextEditingController password2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _showDialog(BuildContext context, String title) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          // code on continue comes here
        };

    BlurryDialog alert = BlurryDialog('خطأ', title, continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'استعادة كلمة المرور',
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
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              _showDialog(context, state.error);
            } else if (state is NewPasswordSetSuccessfully)
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                  (route) => false);
          },
          builder: (context, state) => ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                          ),
                          Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.contain,
                            height: 0.14.sh,
                            width: 0.4.sw,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'برجاء ادخال كلمة مرور جديدة',
                            style: TextStyle(
                                fontSize: 19.sp,
                                color: Color(Constants.mainColor)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 0.12.sh,
                            child: TextFormField(
                              style: TextStyle(fontSize: 20.sp),
                              controller: password,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !seePassword,
                              decoration: new InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Color(0xffF0F4F8),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        seePassword = !seePassword;
                                      });
                                    },
                                    child: Icon(
                                      seePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  prefixIcon: Image.asset(
                                    'assets/images/icon-padlock.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  hintText: 'كلمة المرور',
                                  hintStyle: TextStyle(
                                      fontSize: 18.sp,
                                      color: Color(0xffA6BCD0)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'كلمة المرور مطلوبة';
                                } else if (value.length < 9) {
                                  return 'كلمة المرور قصيرة';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: 0.12.sh,
                            child: TextFormField(
                              style: TextStyle(fontSize: 20.sp),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !seePassword1,
                              decoration: new InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Color(0xffF0F4F8),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        seePassword1 = !seePassword1;
                                      });
                                    },
                                    child: Icon(
                                      seePassword1
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  prefixIcon: Image.asset(
                                    'assets/images/icon-padlock.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  hintText: 'تاكيد كلمة المرور',
                                  hintStyle: TextStyle(
                                      fontSize: 18.sp,
                                      color: Color(0xffA6BCD0)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                              validator: (val) {
                                if (val != password.text) {
                                  return 'كلمة السر غير متطابقة !';
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 0.90.sw,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthCubit>(context)
                                      .newPassword(
                                          phone: widget.phone,
                                          password: password.text);
                                }
                              },
                              child: Text('حسنا'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(Constants.mainColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
    );
  }
}
