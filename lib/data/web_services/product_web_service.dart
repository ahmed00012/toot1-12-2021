import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:toot/data/models/item_details.dart';

import '../local_storage.dart';

class ProductWebServices {
  late Dio dio;
  getHeaderWithInToken() {
    return {
      'Accept': 'application/json',
      'Content-Language': 'ar',
      'X-Requested-With': 'XMLHttpRequest',
      HttpHeaders.authorizationHeader:
          "Bearer " + LocalStorage.getData(key: 'token')
    };
  }

  getHeaderWithOutToken() {
    return {
      'Accept': 'application/json',
      'Content-Language': 'ar',
      'X-Requested-With': 'XMLHttpRequest'
    };
  }

  ProductWebServices() {
    BaseOptions options = BaseOptions(
        baseUrl: 'https://toot.work/api/',
        receiveDataWhenStatusError: true,
        connectTimeout: 20 * 1000, // 60 seconds,
        receiveTimeout: 20 * 1000,
        headers: LocalStorage.getData(key: 'token') == null
            ? getHeaderWithOutToken()
            : getHeaderWithInToken());

    dio = Dio(options);
  }

  Future<dynamic> fetchCategories({double? lat, double? long}) async {
    try {
      Response response = await dio.get('vendors', queryParameters: {
        'lat': lat ?? 21.543333,
        'long': long ?? 39.172779
      });

      return response.data;
    } on DioError catch (e) {
      print(e.toString());
      throw e.response!.data;
    }
  }

  Future<List<ItemDetails>> fetchBanner() async {
    Response response = await dio.get('sliders?limit=10');
    var body = response.data;
    print(response.data);
    List<ItemDetails> items = [];
    for (int i = 0; i < body['data'].length; i++)
      items.add(ItemDetails.fromJson2(body['data'][i]));
    return items;
  }

  Future<dynamic> fetchShopCategories({int? shopId}) async {
    try {
      Response response = await dio.get('vendors/$shopId/categories');
      return response.data['categories'];
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.response!.data;
    }
  }

  Future<dynamic> fetchItems(
      {int? shopId, int? catId, int? page, String? filter}) async {
    try {
      Response response = await dio.get(
          'vendors/$shopId/$catId/products?filter=$filter',
          queryParameters: {'page': page});
      log(response.data['data'].toString());
      return response.data['data'];
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.response!.data;
    }
  }

  Future<dynamic> fetchItemDetails(int itemId) async {
    try {
      Response response = await dio.get(
        'products/$itemId/details',
      );
      log(response.data.toString());
      return response.data['product'];
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.response!.data;
    }
  }

  Future<dynamic> fetchOffers(int pageNum) async {
    try {
      Response response = await dio.get('customer/notifications?page=$pageNum');
      print(response.data['data']);
      return response.data['data'];
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.response!.data;
    }
  }
}
