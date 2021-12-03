import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toot/data/repositories/favorites_repository.dart';
import 'package:toot/data/web_services/favorites_web_service.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesRepository favoritesRepository =
      FavoritesRepository(FavoritesWebServices());
  FavoritesCubit() : super(FavoritesInitial());
  @override
  void onChange(Change<FavoritesState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  Future<void> toggleFavoriteStatus(
      {required int itemId, required int vendorId}) async {
    favoritesRepository
        .toggleFavoriteStatus(itemId: itemId, vendorId: vendorId)
        .then((value) {
      if (value == true) {
        print('toggle favorite status done !');
      }
    });
  }

  Future<void> removeFromFavorites({required int itemId}) async {
    favoritesRepository.toggleFavoriteStatus(itemId: itemId).then((value) {
      if (value == true) {
        deleteFavorite(itemId);
        print('removed from favorites');
      }
    });
  }

  void deleteFavorite(int id) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final fav = currentState.favorites;
      fav.removeWhere((element) => element.productId == id);
      emit(FavoritesLoaded(favorites: fav));
    }
  }

  Future<void> fetchFavorites() async {
    emit(FavoritesLoading());
    favoritesRepository.fetchFavorites().then((fetchedFavorites) {
      emit(FavoritesLoaded(favorites: fetchedFavorites));
    });
  }
}
