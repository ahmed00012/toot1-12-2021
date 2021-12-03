part of 'product_cubit.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class CategoriesLoading extends ProductState {}

class CategoriesLoaded extends ProductState {
  final List<dynamic> categories;
  final List<ItemDetails>? items;
  CategoriesLoaded({required this.categories, this.items});
}

class ShopCategoriesLoading extends ProductState {}

class ShopCategoriesLoaded extends ProductState {
  final List<dynamic> shopCategories;
  ShopCategoriesLoaded({required this.shopCategories});
}

class ItemDetailsLoading extends ProductState {}

class ItemDetailsLoaded extends ProductState {
  final ItemDetails itemDetails;
  double? price;
  int? optionId;
  ItemDetailsLoaded({required this.itemDetails, this.price, this.optionId});
}

class ErrorOccur extends ProductState {
  final String error;
  ErrorOccur({required this.error});
}
