import 'package:bloc/bloc.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/data/repositories/auth_repository.dart';
import 'package:toot/data/web_services/auth_web_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository = AuthRepository(AuthWebServices());
  AuthCubit() : super(AuthInitial());

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  Future<void> register(
      {String? name,
      String? email,
      String? phone,
      String? password,
      String? identityNo,
      String? confirmPassword}) async {
    emit(AuthLoading());
    await authRepository
        .register(
      name: name,
      identityNo: identityNo,
      password: password,
      phone: phone,
    )
        .then((value) {
      emit(AuthLoaded());
    }).catchError((e) {
      emit(AuthError(error: e.toString()));
    });
  }

  login({String? phone, String? password}) async {
    emit(AuthLoading());
    print('token_device.....' + LocalStorage.getData(key: 'token_fcm'));
    LocalStorage.saveData(key: 'counter', value: 0);
    await authRepository
        .login(
      password: password,
      phone: phone,
    )
        .then((data) async {
      LocalStorage.saveData(key: 'token', value: data['access_token']);
      LocalStorage.saveData(key: 'isLogin', value: true);
      LocalStorage.saveData(key: 'phone', value: data['phone']);
      LocalStorage.saveData(key: 'name', value: data['name']);
      LocalStorage.saveData(key: 'counter', value: 0);
      LocalStorage.saveData(
          key: 'identity', value: data['identity_number'].toString());
      emit(AuthLoaded());
    }).catchError((e) {
      emit(AuthError(error: e.toString()));
    });
  }

  Future<void> fetchIntroductionImages() async {
    emit(ImagesLoading());
    authRepository.fetchIntroductionImages().then((images) {
      emit(ImagesLoaded(images: images));
    }).catchError((e) {
      emit(AuthError(error: e.toString()));
    });
  }

  otp({
    String? phone,
    String? otp,
    String? name,
    String? password,
    String? email,
  }) async {
    await authRepository
        .otp(
            phone: phone,
            otp: otp,
            password: password,
            email: email,
            name: name,
            fcmToken: LocalStorage.getData(key: 'token_fcm'))
        .then((data) async {
      LocalStorage.saveData(key: 'token', value: data['access_token']);
      LocalStorage.saveData(key: 'isLogin', value: true);
      LocalStorage.saveData(key: 'phone', value: data['phone']);
      LocalStorage.saveData(key: 'name', value: data['name']);
      LocalStorage.saveData(key: 'counter', value: 0);
      LocalStorage.saveData(
          key: 'identity', value: data['identity_number'].toString());
      emit(OtpSuccess());
    });
  }

  Future<void> forgetPassword({
    String? phone,
  }) async {
    print('ooo' + phone.toString());
    await authRepository.forgetPassword(
      phone: phone,
    );
    emit(ForgetPasswordSuccess());
  }

  Future<void> verifyForgetPassword({String? phone, String? otp}) async {
    try {
      var verify =
          await authRepository.verifyForgetPassword(phone: phone, otp: otp);
      if (verify == true) {
        emit(VerifyForgetPasswordSuccess());
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }

    //     .then((value) async {
    //   if (value == true) {
    //     print('verifyForgetPassword done !');
    //     emit(VerifyForgetPasswordSuccess());
    //   }
    // }).catchError((e) {
    //   emit(AuthError(error: e.toString()));
    // });
  }

  Future<void> newPassword({
    String? phone,
    String? password,
  }) async {
    await authRepository
        .newPassword(phone: phone, password: password)
        .then((value) async {
      if (value == true) {
        print('newPassword done !');
        emit(NewPasswordSetSuccessfully());
      }
    }).catchError((e) {
      emit(AuthError(error: e.toString()));
    });
  }

  Future<void> updateProfile({
    String? name,
    String? identity,
  }) async {
    emit(ProfileUpdating());
    await authRepository
        .updateProfile(name: name, identity: identity)
        .then((value) async {
      if (value == true) {
        emit(ProfileUpdated());
      }
    }).catchError((e) {
      emit(AuthError(error: e.toString()));
    });
  }
}
