part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class AddedToCart extends CartState {}

class CartLoaded extends CartState {
  final CartItem cartDetails;
  List? payments;
  CartLoaded({required this.cartDetails, this.payments});
}

class CartEmpty extends CartState {}

class AddressesLoaded extends CartState {
  final List addresses;
  AddressesLoaded({required this.addresses});
}

class PromoLoaded extends CartState {
  final promo;
  PromoLoaded({required this.promo});
}

class PaymentsLoaded extends CartState {
  final List payments;
  PaymentsLoaded({required this.payments});
}

class PaymentAdded extends CartState {
  String? method;
  String? url;
  PaymentAdded({required this.method, this.url});
}

class PaymentLoading extends CartState {}

class OrderConfirmed extends CartState {
  final int num;
  OrderConfirmed({required this.num});
}

class InfoLoaded extends CartState {
  final Info info;
  InfoLoaded({required this.info});
}

class OrderStatusLoading extends CartState {}

class OrderStatusLoaded extends CartState {
  final Order order;
  OrderStatusLoaded({required this.order});
}

class CartError extends CartState {
  final String error;
  CartError({required this.error});
}

class LastOrdersLoading extends CartState {}

class LastOrdersLoaded extends CartState {
  final List orders;
  LastOrdersLoaded({required this.orders});
}

class MyPointsLoading extends CartState {}

class MyPointsLoaded extends CartState {
  final Points points;
  MyPointsLoaded({required this.points});
}

class NewBalancedLoading extends CartState {}

class NewBalancedFetched extends CartState {
  final String newBalance;
  NewBalancedFetched({required this.newBalance});
}
