import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:toot/presentation/screens/single_item_screen.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';

import '../../constants.dart';
import 'cart_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    BlocProvider.of<FavoritesCubit>(context).fetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BuildAppBar(
          title: 'المفضلة',
        ),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoaded) {
              final fav = state.favorites;
              if (fav.isEmpty)
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Center(
                      child: Lottie.asset(
                          'assets/images/78022-no-favorite-icon.json',
                          height: 200),
                    ),
                    Text(
                      'المفضلة فارغة',
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ],
                );
              else
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                      vertical: 0.01.sh, horizontal: 0.05.sw),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => FavoriteItem(
                    name: fav[index].product!.name!,
                    image: fav[index].product!.imageOne,
                    price: fav[index].product!.price!,
                    id: fav[index].productId!,
                    shopId: fav[index].vendorId!,
                    isFav: fav[index].product!.inFavourite == 1 ? true : false,
                  ),
                  itemCount: fav.length,
                );
            } else {
              return Center(
                  child: Container(
                height: 120,
                width: 120,
                child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
              ));
              // return AlertDialog(
              //   backgroundColor: Colors.transparent,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15)),
              //   elevation: 0,
              //   content: Center(
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(15),
              //       child: Image.asset(
              //         'assets/images/loading.gif',
              //         height: 0.4.sw,
              //         width: 0.4.sw,
              //       ),
              //     ),
              //   ),
              // );
            }
          },
        ));
  }
}

class FavoriteItem extends StatefulWidget {
  final String name;
  final String price;
  final String? image;
  final int id;
  final int shopId;
  final bool isFav;

  FavoriteItem(
      {this.image,
      required this.name,
      required this.price,
      required this.id,
      required this.shopId,
      required this.isFav});

  @override
  _FavoriteItemState createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 0.18.sh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        child: Row(
          children: [
            widget.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.image!,
                      fit: BoxFit.contain,
                      height: 0.2.sw,
                      width: 0.2.sw,
                    ),
                  )
                : Image.asset(
                    'assets/images/دون صوره.png',
                  ),
            SizedBox(
              width: 0.08.sw,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 0.4.sw,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(Constants.mainColor),
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Text(
                  '${widget.price}  SAR',
                  style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  width: 0.35.sw,
                  height: 0.042.sh,
                  child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (_) => SingleItemScreen(
                                    id: widget.id,
                                    title: widget.name,
                                    price: double.parse(widget.price),
                                    removeFav: true,
                                    shopId: widget.shopId,
                                    isFav: true)))
                            .then((value) {
                          if (value != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Color(Constants.mainColor),
                              content: Text(
                                'تم اضافة المنتج بنجاح.',
                                style: TextStyle(
                                    fontSize: 14, fontFamily: 'Tajawal'),
                              ),
                              action: SnackBarAction(
                                label: 'الذهاب الي السلة',
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => CartScreen()));
                                },
                              ),
                            ));
                          }
                        });
                      },
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: Color(Constants.mainColor),
                        size: 18,
                      ),
                      label: Text(
                        'اضافة الي السله',
                        style: TextStyle(fontSize: 14.sp),
                      )),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Color(0xffFD8C44),
                size: 30,
              ),
              onPressed: () {
                BlocProvider.of<FavoritesCubit>(context)
                    .removeFromFavorites(itemId: widget.id)
                    .then((value) => Fluttertoast.showToast(
                        msg: "تم حذف المنتج بنجاح من المفضلة.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Color(Constants.mainColor),
                        textColor: Colors.white,
                        fontSize: 16.0));
              },
            ),
            SizedBox(
              width: 0.04.sw,
            ),
          ],
        ),
      ),
    );
  }
}
