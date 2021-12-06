import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/cubits/product_cubit/product_cubit.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/presentation/screens/auth_screen.dart';
import 'package:toot/presentation/screens/items_screen.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';

import '../../constants.dart';
import 'cart_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final int shopId;
  final String shopName;

  CategoriesScreen({required this.shopId, required this.shopName});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? counter = "0";
  bool isLogin = false;
  @override
  void initState() {
    getShopCat();
    super.initState();
  }

  getShopCat() {
    setState(() {
      LocalStorage.getData(key: 'counter') != null
          ? counter = LocalStorage.getData(key: 'counter').toString()
          : counter = '0';
      LocalStorage.getData(key: 'isLogin') != null
          ? isLogin = LocalStorage.getData(key: 'isLogin')
          : isLogin = false;
    });
    BlocProvider.of<ProductCubit>(context)
        .fetchShopCategories(shopId: widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomNavBar()));
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              widget.shopName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(Constants.mainColor),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25,
                color: Color(Constants.mainColor),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()));
              },
            ),
            actions: [
              InkWell(
                onTap: () {
                  if (!isLogin)
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                        (route) => false);
                  else
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 9.0, left: 9),
                  child: Badge(
                      position: BadgePosition.topStart(),
                      elevation: 5,
                      badgeColor: Colors.white,
                      badgeContent: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          counter!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[400]),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 15.0, left: 2, right: 2),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 28,
                          color: Colors.green[400],
                        ),
                      )),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25))),
          ),
          body: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ShopCategoriesLoaded) {
                final shopCat = state.shopCategories;
                return GridView.builder(
                  itemCount: shopCat.length,
                  padding: EdgeInsets.only(
                    top: 0.03.sh,
                    right: 0.05.sw,
                    left: 0.05.sw,
                  ),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2.5,
                  ),
                  itemBuilder: (context, index) => CategoryItem(
                    image: shopCat[index].image.toString(),
                    title: shopCat[index].name,
                    shopId: widget.shopId,
                    categoryId: shopCat[index].id,
                    categories: shopCat,
                    function: getShopCat,
                    index: index,
                  ),
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
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String image;
  final String title;
  final int shopId;
  final int categoryId;
  final List categories;
  final int index;
  final Function function;

  CategoryItem(
      {required this.image,
      required this.title,
      required this.categories,
      required this.categoryId,
      required this.shopId,
      required this.function,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => ItemsScreen(
                    categories: categories,
                    catId: categoryId,
                    shopId: shopId,
                    index: index)))
            .then((value) {
          return function();
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        height: 0.3.sh,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.toString() != "null"
                  ? Image.network(
                      image,
                      height: 0.2.sh,
                      width: 0.3.sw,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      'assets/images/دون صوره.png',
                      height: 0.2.sh,
                      width: 0.3.sw,
                      fit: BoxFit.contain,
                    ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(
                    Constants.mainColor,
                  ),
                  fontSize: 16.sp),
            )
          ],
        ),
      ),
    );
  }
}
