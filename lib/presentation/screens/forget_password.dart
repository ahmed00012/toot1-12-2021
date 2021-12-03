import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toot/cubits/auth_cubit/auth_cubit.dart';
import 'package:toot/presentation/widgets/default_text_field.dart';

import '../../constants.dart';
import 'activate_account_screen.dart';

class ForgetPassword extends StatelessWidget {
  final _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 0.08.sw),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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
                      'برجاء ادخال رقم الجوال',
                      style: TextStyle(
                          fontSize: 19.sp, color: Color(Constants.mainColor)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BuildTextField(
                      controller: _phone,
                      icon: 'assets/images/smartphone.png',
                      hint: 'رقم الجوال',
                      isNumeric: true,
                      validator: (val) {
                        if (!val.contains('05') || val.length != 10) {
                          return 'رقم الجوال غير صالح !';
                        }
                      },
                    ),
                    SizedBox(
                      width: 0.90.sw,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print(_phone.text);
                            BlocProvider.of<AuthCubit>(context)
                                .forgetPassword(phone: _phone.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivateAccountScreen(
                                          phone: _phone.text,
                                        )));
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
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
