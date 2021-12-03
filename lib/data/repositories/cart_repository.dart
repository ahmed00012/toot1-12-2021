import 'package:dio/dio.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/data/models/address.dart';
import 'package:toot/data/models/cart_item.dart';
import 'package:toot/data/models/info.dart';
import 'package:toot/data/models/last_order.dart';
import 'package:toot/data/models/order.dart';
import 'package:toot/data/models/payment.dart';
import 'package:toot/data/models/points.dart';
import 'package:toot/data/models/promo_status.dart';
import 'package:toot/data/web_services/cart_web_service.dart';

class CartRepository {
  final CartWebServices cartWebServices;
  CartRepository(this.cartWebServices);

  Future<dynamic> addToCart(
      {int? shopId,
      int? productId,
      int? quantity,
      String? cartToken,
      List? extras,
      List? options}) async {
    FormData formData = FormData.fromMap({
      'vendor_id': shopId,
      'product_id': productId,
      'quantity': quantity,
      'cart_token': cartToken,
      'options': options,
      'addons': extras
    });
    return await cartWebServices.addToCart(formData);
  }

  Future<dynamic> removeFromCart(
      {int? productId, String? cartToken, bool? lastItem}) async {
    print(lastItem);

    // FormData formData =
    //     FormData.fromMap({'product_id': productId, 'cart_token': cartToken});
    return await cartWebServices.removeFromCart(productId, cartToken, lastItem);
  }

  Future<dynamic> fetchCart() async {
    final rawData = await cartWebServices.fetchCart();
    print("rawData $rawData");
    if (rawData != null && rawData['success'] != "0") {
      print(rawData['data']['token'].toString() + 'dfkdgiy');
      LocalStorage.saveData(
          key: 'cart_token', value: rawData['data']['token'].toString());
      return CartItem.fromJson(rawData);
    } else
      return "Empty";
  }

  Future<dynamic> fetchAddress() async {
    final rawData = await cartWebServices.fetchAddress();
    return rawData.map((address) => Address.fromJson(address)).toList();
  }

  Future<dynamic> addAddress(
      {String? cartToken,
      String? address,
      String? district,
      double? lat,
      double? lng}) async {
    FormData formData = FormData.fromMap({
      'cart_token': cartToken,
      'address': address,
      'district': district,
      'lng': lng,
      'lat': lat
    });
    return await cartWebServices.addAddress(formData);
  }

  Future<dynamic> selectAddress({String? cartToken, int? addressId}) async {
    return await cartWebServices.selectAddress(addressId);
  }

  Future<dynamic> fetchPayments() async {
    final rawData = await cartWebServices.fetchPayments();
    return rawData.map((address) => Payment.fromJson(address)).toList();
  }

  Future<dynamic> selectPayment({
    String? cartToken,
    String? method,
  }) async {
    FormData formData =
        FormData.fromMap({'cart_token': cartToken, 'payment_type': method});
    return await cartWebServices.selectPayment(formData);
  }

  Future<dynamic> confirmOrder({String? cartToken}) async {
    FormData formData = FormData.fromMap({'cart_token': cartToken});
    return await cartWebServices.confirmOrder(formData);
  }

  Future<dynamic> promoCode({String? cartToken, String? code}) async {
    FormData formData =
        FormData.fromMap({'cart_token': cartToken, 'code': code});
    final rawData = await cartWebServices.promoCode(formData);
    if (rawData["success"].toString() == "0")
      return PromoStatus.fromJson1(rawData);
    else
      return PromoStatus.fromJson(rawData);
  }

  Future<dynamic> fetchDatesAndTimes({int? id}) async {
    final rawData = await cartWebServices.fetchDatesAndTimes(id: id);
    return Info.fromJson(rawData);
  }

  Future<dynamic> confirmInfoDateAndTime(
      {String? date, int? id, String? token}) async {
    FormData formData =
        FormData.fromMap({'date': date, 'time_id': id, 'cart_token': token});
    return await cartWebServices.confirmInfoDateAndTime(formData);
  }

  Future<dynamic> orderStatus(int? id) async {
    var data = await cartWebServices.orderStatus(id!);

    return Order.fromJson(data);
  }

  Future<dynamic> fetchLastOrders() async {
    final rawData = await cartWebServices.fetchLastOrders();
    return rawData.map((order) => LastOrder.fromJson(order)).toList();
  }

  Future<dynamic> fetchMyPoints() async {
    final rawData = await cartWebServices.fetchMyPoints();
    return Points.fromJson(rawData);
  }

  Future<dynamic> covertPoints() async {
    final rawData = await cartWebServices.covertPoints();
    return rawData;
  }
}
