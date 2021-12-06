import 'dart:developer';

import 'package:dio/dio.dart';

import '../local_storage.dart';

class AuthWebServices {
  late Dio dio;

  AuthWebServices() {
    BaseOptions options = BaseOptions(
        baseUrl: 'https://toot.work/api/',
        receiveDataWhenStatusError: true,
        connectTimeout: 20 * 1000, // 60 seconds,
        receiveTimeout: 20 * 1000,
        headers: {
          'Content-Type': 'application/json',
          'Content-Language': 'ar',
        });

    dio = Dio(options);
  }

  Future<dynamic> register(FormData formData) async {
    try {
      Response response = await dio.post('auth/register', data: formData);
      return response.data['success'];
    } on DioError catch (e) {
      Map errors = e.response!.data['error'];
      if (errors.containsKey('phone') && errors.containsKey('email')) {
        throw ('البريد الالكتروني و رقم الهاتف مُستخدمان من قبل');
      } else if (errors.containsKey('phone')) {
        throw ('رقم الهاتف مُستخدم من قبل');
      } else if (errors.containsKey('email')) {
        throw ('البريد الالكتروني مُستخدم من قبل');
      }
    }
  }

  login(FormData formData) async {
    try {
      Response response = await dio.post('auth/login', data: formData);
      log(response.data.toString());
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data['message'];
    }
  }

  Future<dynamic> fetchIntroductionImages() async {
    try {
      Response response = await dio.get('settings/app');
      return response.data['cities_slider'];
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  otp(FormData formData) async {
    try {
      Response response = await dio.post('auth/verify', data: formData);
      if (response.data['success'] == '1') {
        log(response.data.toString());
        return response.data;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<bool> forgetPassword(FormData formData) async {
    try {
      Response response =
          await dio.post('auth/forget-password', data: formData);
      if (response.data['success'] == '1') {
        return true;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      print(e.response!.data);
      return false;
    }
  }

  Future<bool> verifyForgetPassword(FormData formData) async {
    try {
      Response response =
          await dio.post('auth/verify-forget-password', data: formData);
      if (response.data['success'] == '1') {
        return true;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      print(e.response!.data);
      return false;
    }
  }

  Future<bool> newPassword(FormData formData) async {
    try {
      Response response = await dio.post('auth/new-password', data: formData);
      if (response.data['success'] == '1') {
        return true;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      print(e.response!.data);
      return false;
    }
  }

  Future<bool> updateProfile(FormData formData) async {
    try {
      Response response = await dio.post('customer/update',
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
          }));
      if (response.data['success'] == '1') {
        return true;
      } else {
        throw response.data['message'];
      }
    } on DioError catch (e) {
      print(e.response!.data);
      return false;
    }
  }
}
