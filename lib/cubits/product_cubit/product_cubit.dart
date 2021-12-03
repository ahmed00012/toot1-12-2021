import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/data/models/item_details.dart';
import 'package:toot/data/repositories/product_repository.dart';
import 'package:toot/data/web_services/product_web_service.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductRepository productRepository = ProductRepository(ProductWebServices());
  ProductCubit() : super(ProductInitial());

  @override
  void onChange(Change<ProductState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  late double latitude;
  late double longitude;
  List? offers;

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      LocalStorage.saveData(key: 'long', value: longitude);
      LocalStorage.saveData(key: 'lat', value: latitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCategories() async {
    emit(CategoriesLoading());
    getLocation();
    List<ItemDetails> items = await productRepository.fetchBanner();
    var categories = await productRepository.fetchCategories(
        long: LocalStorage.getData(key: 'long'),
        lat: LocalStorage.getData(key: 'lat'));

    emit(
      CategoriesLoaded(categories: categories, items: items),
    );
    // productRepository.fetchCategories(long: long, lat: lat).then((categories) {
    //   emit(
    //     CategoriesLoaded(categories: categories, items: items),
    //   );
    // }).catchError((e) {
    //   emit(ErrorOccur(error: e.toString()));
    // });
  }

  Future<void> fetchShopCategories({int? shopId}) async {
    emit(ShopCategoriesLoading());
    productRepository
        .fetchShopCategories(shopId: shopId)
        .then((shopCategories) {
      emit(
        ShopCategoriesLoaded(shopCategories: shopCategories),
      );
    }).catchError((e) {
      emit(ErrorOccur(error: e.toString()));
    });
  }

  Future<dynamic> fetchItemDetails(int itemId) async {
    emit(ItemDetailsLoading());
    var itemDetails = await productRepository.fetchItemDetails(itemId);
    if (itemDetails.options.isNotEmpty)
      emit(ItemDetailsLoaded(
          itemDetails: itemDetails,
          price: double.parse(itemDetails.options[0].price),
          optionId: itemDetails.options[0].id));
    else
      emit(ItemDetailsLoaded(
          itemDetails: itemDetails, price: double.parse(itemDetails.price)));
  }

  // Future<dynamic> fetchOffers(int pageNum) async {
  //   try {
  //     productRepository.fetchOffers(pageNum).then((fetchOffer) => fetchOffer);
  //   } catch (e) {
  //     emit(ErrorOccur(error: e.toString()));
  //   }
  // }
}
