import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTextField extends StatelessWidget {
  final String hint;
  final String icon;
  final Function? onSaved;
  final Function? validator;
  final TextEditingController? controller;
  bool isObscure;
  final bool isNumeric;
  final bool? password;

  BuildTextField(
      {required this.hint,
      required this.icon,
      this.onSaved,
      this.validator,
      this.controller,
      this.isObscure = false,
      this.isNumeric = false,
      this.password});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.10.sh,
      child: TextFormField(
          style: TextStyle(fontSize: 20.sp),
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Color(0xffF0F4F8),
              hintText: hint,
              prefixIcon: Image.asset(
                icon,
                height: 50,
                width: 50,
                color: Color(0xffA6BCD0),
              ),
              hintStyle: TextStyle(fontSize: 18.sp, color: Color(0xffA6BCD0)),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              )),
          onSaved: (val) {
            return onSaved!(val);
          },
          keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
          validator: (val) {
            return validator!(val);
          }),
    );
  }
}
