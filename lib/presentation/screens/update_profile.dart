import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toot/constants.dart';
import 'package:toot/cubits/auth_cubit/auth_cubit.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/presentation/widgets/default_text_field.dart';

class UpdateProfile extends StatelessWidget {
  String? name;
  String? identity;
  UpdateProfile({this.name, this.identity});
  TextEditingController _name = new TextEditingController();
  TextEditingController _identity = new TextEditingController();
  bool updated = false;

  @override
  Widget build(BuildContext context) {
    _name.text = name!;
    _identity.text = identity ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بياناتي'),
        centerTitle: true,
        backgroundColor: Color(Constants.mainColor),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (_, state) {
            if (state is ProfileUpdated)
              showSimpleNotification(
                  Container(
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'تم تحديث البيانات بنجاح',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  duration: Duration(seconds: 3),
                  background: Colors.white);
          },
          builder: (context, state) {
            if (state is ProfileUpdating)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
                    ),
                  )
                ],
              );
            else
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.indigo)),
                        child: Icon(
                          Icons.person,
                          size: 85,
                          color: Colors.indigo,
                        )

                        // Image.asset(
                        //   "assets/images/user.png",
                        // ) ,
                        ),
                    SizedBox(
                      height: 40,
                    ),
                    BuildTextField(
                      icon: 'assets/images/add card  (2).png',
                      controller: _name,
                      hint: 'الاسم',
                      validator: (String? val) {
                        if (val!.isEmpty || val.length <= 6) {
                          return 'الاسم قصير جدا !';
                        }
                      },
                    ),
                    BuildTextField(
                      icon: 'assets/images/id-card(1).png',
                      controller: _identity,
                      hint: 'رقم الجمعية',
                      isNumeric: true,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<AuthCubit>(context).updateProfile(
                            name: _name.text, identity: _identity.text);
                        LocalStorage.saveData(key: 'name', value: _name.text);
                        LocalStorage.saveData(
                            key: 'identity', value: _identity.text);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Color(Constants.mainColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                          child: Text(
                            'تحديث',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
          },
        ),
      ),
    );
  }
}
