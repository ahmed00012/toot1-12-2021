import 'package:dio/dio.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/data/web_services/auth_web_service.dart';

class AuthRepository {
  final AuthWebServices authWebServices;
  AuthRepository(this.authWebServices);

  Future<dynamic> register(
      {String? name,
      String? identityNo,
      String? phone,
      String? password}) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
      'identity_number': identityNo,
    });
    return await authWebServices.register(formData);
  }

  login({String? phone, String? password}) async {
    FormData formData = FormData.fromMap({
      'phone': phone,
      'password': password,
      'device_id': LocalStorage.getData(key: 'token_fcm')
    });
    return await authWebServices.login(formData);
  }

  Future<dynamic> fetchIntroductionImages() async {
    final rawData = await authWebServices.fetchIntroductionImages();
    return rawData.map((element) => element['img_url']).toList();
  }

  otp(
      {String? phone,
      String? otp,
      String? name,
      String? password,
      String? email,
      String? fcmToken}) async {
    FormData formData = FormData.fromMap({
      'phone': phone,
      'otp': otp,
      'name': name,
      'password': password,
      'email': email,
      'device_id': LocalStorage.getData(key: 'token_fcm')
    });
    return await authWebServices.otp(formData);
  }

  Future<bool> forgetPassword({String? phone}) async {
    FormData formData = FormData.fromMap({
      'phone': phone,
    });
    return await authWebServices.forgetPassword(formData);
  }

  Future<bool> verifyForgetPassword({String? phone, String? otp}) async {
    FormData formData = FormData.fromMap({
      'phone': phone,
      'otp': otp,
    });

    return await authWebServices.verifyForgetPassword(formData);
  }

  Future<bool> newPassword({
    String? phone,
    String? password,
  }) async {
    FormData formData = FormData.fromMap({
      'phone': phone,
      'password': password,
    });
    return await authWebServices.newPassword(formData);
  }

  Future<bool> updateProfile({
    String? name,
    String? identity,
  }) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'identity_number': identity,
    });
    return await authWebServices.updateProfile(formData);
  }
}
