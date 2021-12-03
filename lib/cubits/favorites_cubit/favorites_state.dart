part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List favorites;
  FavoritesLoaded({required this.favorites});
}

class FavoritesError extends FavoritesState {}
