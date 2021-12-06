import 'package:dio/dio.dart';

import '../local_storage.dart';

class CartWebServices {
  // late Dio dio;

  // getHeaderWithInToken() {
  //   return {
  //     'Accept': 'application/json',
  //     'Content-Language': 'ar',
  //     'X-Requested-With': 'XMLHttpRequest',
  //     HttpHeaders.authorizationHeader:
  //         "Bearer " + LocalStorage.getData(key: 'token')
  //   };
  // }
  //
  // getHeaderWithOutToken() {
  //   return {
  //     'Accept': 'application/json',
  //     'Content-Language': 'ar',
  //     'X-Requested-With': 'XMLHttpRequest'
  //   };
  // }

  // CartWebServices() {
  //   BaseOptions options = BaseOptions(
  //       baseUrl: 'https://toot.work/api/',
  //       receiveDataWhenStatusError: true,
  //       connectTimeout: 20 * 1000, // 60 seconds,
  //       receiveTimeout: 20 * 1000,
  //       headers: LocalStorage.getData(key: 'token') == null
  //           ? getHeaderWithOutToken()
  //           : getHeaderWithInToken());
  //
  //   dio = Dio(options);
  // }

  Future<dynamic> addToCart(FormData formData) async {
    try {
      Response response =
          await Dio().post('https://toot.work/api/cart/add_product',
              data: formData,
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future removeFromCart(int? id, String? cardToken, bool? lastItem) async {
    try {
      Response response =
          await Dio().post('https://toot.work/api/cart/remove_product',
              data: {
                "product_id": "$id",
                "cart_token": "$cardToken",
              },
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      if (lastItem!) LocalStorage.removeData(key: 'cart_token');
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> fetchCart() async {
    Response response = await Dio().get(
        'https://toot.work/api/cart/get_cart/${LocalStorage.getData(key: 'cart_token')}',
        options: Options(headers: {
          "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
          "Content-Language": 'ar',
        }));
    return response.data;
  }

  Future<dynamic> fetchAddress() async {
    try {
      Response response =
          await Dio().get('https://toot.work/api/customer/addresses',
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> addAddress(FormData formData) async {
    try {
      Response response =
          await Dio().post('https://toot.work/api/cart/add_address',
              data: formData,
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> selectAddress(int? addressId) async {
    try {
      Response response = await Dio().post(
          'https://toot.work/api/cart/choose_address',
          data: {
            'cart_token': LocalStorage.getData(key: 'cart_token'),
            'address_id': addressId
          },
          options: Options(headers: {
            "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
          }));

      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> fetchPayments() async {
    Response response =
        await Dio().get('https://toot.work/api/cart/payment_method',
            options: Options(headers: {
              "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
            }));
    return response.data;
  }

  Future<dynamic> selectPayment(FormData formData) async {
    Response response =
        await Dio().post('https://toot.work/api/cart/add_payment',
            data: formData,
            options: Options(headers: {
              "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
            }));
    return response.data;
  }

  Future<dynamic> confirmOrder(FormData formData) async {
    Response response = await Dio().post('https://toot.work/api/cart/confirm',
        data: formData,
        options: Options(headers: {
          "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
        }));
    return response.data;
  }

  Future<dynamic> promoCode(FormData formData) async {
    Response response =
        await Dio().post('https://toot.work/api/cart/add_coupon',
            data: formData,
            options: Options(headers: {
              "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
            }));
    return response.data;
  }

  Future<dynamic> fetchDatesAndTimes({int? id}) async {
    try {
      Response response =
          await Dio().get('https://toot.work/api/cart/dates_times/$id',
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
                "Content-Language": 'ar'
              }));

      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> confirmInfoDateAndTime(FormData formData) async {
    try {
      Response response =
          await Dio().post('https://toot.work/api/cart/add_delivery_date',
              data: formData,
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> orderStatus(int id) async {
    try {
      Response response =
          await Dio().get('https://toot.work/api/orders/$id/details',
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> fetchLastOrders() async {
    Response response = await Dio().get('https://toot.work/api/customer/orders',
        options: Options(headers: {
          "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
          // 'Content-Language': 'ar',
        }));
    return response.data;
  }

  Future<dynamic> fetchMyPoints() async {
    try {
      Response response =
          await Dio().get('https://toot.work/api/customer/points',
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  Future<dynamic> covertPoints() async {
    try {
      Response response =
          await Dio().get('https://toot.work/api/customer/convert-points',
              options: Options(headers: {
                "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
              }));
      return response.data['balance'];
    } on DioError catch (e) {
      throw e.response!.data;
    }
  }

  // removeCart() async {
  //   Response response =
  //       await Dio().post('http://127.0.0.1:8000/api/cart/remove',
  //           data: {
  //         "cart_token":LocalStorage.getData(key: 'cart_token')
  //           },
  //           options: Options(headers: {
  //             "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
  //           }));
  // }
}
