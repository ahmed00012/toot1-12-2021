import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/cubits/auth_cubit/auth_cubit.dart';
import 'package:toot/presentation/widgets/onboarding_preview.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).fetchIntroductionImages();
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
          builder: (BuildContext context, state) {
        if (state is ImagesLoaded) {
          final images = state.images;
          print(images);
          return ImagesSlider(
            imagesPreview: images,
          );
        } else {
          return Center(
              child: Container(
            height: 120,
            width: 120,
            child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
          ));
        }
      }),
    );
  }
}
