import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:toot/cubits/cart_cubit/cart_cubit.dart';
import 'package:toot/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:toot/data/local_storage.dart';
import 'package:toot/data/models/item.dart';
import 'package:toot/data/web_services/product_web_service.dart';
import 'package:toot/presentation/screens/single_item_screen.dart';
import 'package:toot/presentation/widgets/blurry_dialog.dart';

import '../../constants.dart';
import 'auth_screen.dart';
import 'cart_screen.dart';

class ItemsScreen extends StatefulWidget {
  final List categories;
  final int shopId;
  final int catId;
  final int index;

  ItemsScreen(
      {required this.categories,
      required this.shopId,
      required this.catId,
      required this.index});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  static const _pageSize = 5;
  late int id;
  int? counter = 0;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  TextEditingController _search = TextEditingController();
  bool loading = false;
  String cart = '';
  bool isLogin = false;

  removeCart() async {
    print(LocalStorage.getData(key: 'cart_token'));
    var response = await Dio().post('https://toot.work/api/cart/remove',
        data: {"cart_token": cart},
        options: Options(headers: {
          "Authorization": "Bearer ${LocalStorage.getData(key: 'token')}",
        }));
    print(response.data);
  }

  Future<bool> _showMyDialog(int id) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Center(
              child: const Text(
            'خطأ',
            style: TextStyle(color: Colors.red),
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('عذرا لا يمكنك الطلب من اكثر من فرع'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: const Text(
                'استكمال طلبك السابق',
                style: TextStyle(color: Color(0xff7C39CB)),
              ),
            ),
            TextButton(
              child: const Text(
                'الغاء طلبك',
                style: TextStyle(color: Color(0xff7C39CB)),
              ),
              onPressed: () async {
                setState(() {
                  LocalStorage.saveData(key: 'counter', value: 0);
                  LocalStorage.saveData(key: 'cart_token', value: '');
                  LocalStorage.saveData(key: 'vendor', value: widget.shopId);
                  counter = 1;
                });
                await removeCart();

                BlocProvider.of<CartCubit>(context).addToCart(
                    shopId: widget.shopId,
                    productId: id,
                    quantity: 1,
                    options: [],
                    extras: []);

                Navigator.of(context1).pop(true);
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }

  Future<void> _fetchPage(int pageKey, int catId, String filter) async {
    try {
      var rawData = [];
      List newItems = [];
      rawData = await ProductWebServices().fetchItems(
          shopId: widget.shopId, catId: catId, page: pageKey, filter: filter);
      newItems = rawData.map((item) => Item.fromJson(item)).toList();
      rawData = [];

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems, search:false);
        newItems = [];
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey, search:false);
        newItems = [];
      }
    } catch (error) {
      _pagingController.error = error;
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _searchePage(int pageKey, int catId, String filter) async {
    try {
      List osama = [];
      var rawData = [];
      List newItems = osama;
      rawData = await ProductWebServices().fetchItems(
          shopId: widget.shopId, catId: catId, page: pageKey, filter: filter);
      newItems = rawData.map((item) => Item.fromJson(item)).toList();
      rawData = [];

      print(newItems.length);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems, search:false);
        newItems = [];
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey, search:false);
        newItems = [];
      }
    } catch (error) {
      _pagingController.error = error;
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _changeTab(int pageKey, int catId, String filter) async {
    try {
      var rawData = [];
      List newItems = [];
      rawData = await ProductWebServices().fetchItems(
          shopId: widget.shopId, catId: catId, page: pageKey, filter: filter);
      newItems = rawData.map((item) => Item.fromJson(item)).toList();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems, search:true);
        newItems = [];
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey, search:true);
        newItems = [];
      }
    } catch (error) {
      _pagingController.error = error;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    counter = LocalStorage.getData(key: 'counter') ?? 0;
    cart = LocalStorage.getData(key: "cart_token") ?? '';
    LocalStorage.getData(key: 'isLogin') != null
        ? isLogin = LocalStorage.getData(key: 'isLogin')
        : isLogin = false;
    tabController = TabController(
      vsync: this,
      length: widget.categories.length,
      initialIndex: widget.index,
    );

    id = widget.catId;

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, id, '');
    });
    print(widget.shopId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
              color: Color(Constants.mainColor),
            ),
            splashRadius: 25,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'المنتجات',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(Constants.mainColor),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          // toolbarHeight: 0.18.sh,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: InkWell(
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
                  padding: const EdgeInsets.only(left: 9),
                  child: Badge(
                      position: BadgePosition.topStart(),
                      elevation: 5,
                      badgeColor: Colors.white,
                      badgeContent: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          counter.toString(),
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
            ),
          ],
        ),
        body: Container(
          width: 1.sw,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                width: 1.sw,
                child: Column(
                  children: [
                    Center(
                      child: TabBar(
                        isScrollable: true,
                        controller: tabController,
                        tabs: widget.categories.map((e) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _pagingController.itemList = [];
                              id = e.id;
                              _changeTab(
                                  _pagingController.firstPageKey, e.id, '');
                              tabController
                                  .animateTo(widget.categories.indexOf(e));
                              setState(() {});
                            },
                            child: Tab(
                              child: Text(
                                e.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(Constants.mainColor),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        indicator: RectangularIndicator(
                          color: Colors.grey.shade100,
                          horizontalPadding: 3,
                          verticalPadding: 3,
                          bottomRightRadius: 25,
                          bottomLeftRadius: 25,
                          topLeftRadius: 25,
                          topRightRadius: 25,
                          paintingStyle: PaintingStyle.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                      child: TextField(
                        controller: _search,
                        style: TextStyle(color: Color(Constants.mainColor)),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(Constants.mainColor),
                            size: 25,
                          ),
                          hintText: 'بحث سريع',
                          hintStyle: TextStyle(
                              color: Color(Constants.mainColor),
                              fontSize: 18.sp),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            loading = true;
                            _pagingController.itemList = [];
                            _searchePage(1, id, value);
                          });

                          //
                          // _fetchPage(_pagingController.firstPageKey, id, value);

                          // setState(() {
                          //   loading = true;
                          //   newItems = [];
                          // });

                          // final rawData = await ProductWebServices().fetchItems(
                          //     shopId: widget.shopId,
                          //     catId: widget.catId,
                          //     page: 1,
                          //     filter: value);
                          // setState(() {
                          //   newItems = rawData
                          //       .map((item) => Item.fromJson(item))
                          //       .toList();
                          // });
                          // print(newItems.length);
                          // final isLastPage = newItems.length < _pageSize;
                          // if (isLastPage) {
                          //   _pagingController.appendLastPage(newItems);
                          // }
                          // setState(() {
                          //   loading = false;
                          // });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: loading
                    ? Center(
                        child: Container(
                        height: 120,
                        width: 120,
                        child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
                      ))
                    : PagedGridView<int, dynamic>(
                        // showNewPageProgressIndicatorAsGridChild: false,
                        // showNewPageErrorIndicatorAsGridChild: false,
                        showNoMoreItemsIndicatorAsGridChild: false,
                        pagingController: _pagingController,
                        padding: EdgeInsets.symmetric(
                            vertical: 0.02.sh, horizontal: 0.05.sw),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.6),
                        builderDelegate: PagedChildBuilderDelegate<dynamic>(
                            noMoreItemsIndicatorBuilder: (_) => Container(),
                            newPageErrorIndicatorBuilder: (_) => Container(),
                            noItemsFoundIndicatorBuilder: (_) => Container(
                                height: 0.8.sh,
                                child: Center(
                                    child: Container(
                                  height: 120,
                                  width: 120,
                                  child: Lottie.asset(
                                      'assets/images/lf20_j1klguuo.json'),
                                ))),
                            itemBuilder: (context, item, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (_) => SingleItemScreen(
                                      id: item.id,
                                      title: item.name,
                                      price: double.parse(item.price),
                                      shopId: widget.shopId,
                                      isFav:
                                          item.inFavourite == 1 ? true : false,
                                      count: item.count,
                                    ),
                                  ))
                                      .then((value) {
                                    if (value.toString() == 'added') {
                                      setState(() {
                                        item.inCart = true;
                                        counter = LocalStorage.getData(
                                            key: 'counter');
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor:
                                            Color(Constants.mainColor),
                                        content: Text(
                                          'تم اضافة المنتج بنجاح.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Tajawal'),
                                        ),
                                        action: isLogin
                                            ? SnackBarAction(
                                                label: 'الذهاب الي السلة',
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              CartScreen()));
                                                },
                                              )
                                            : SnackBarAction(
                                                label: '',
                                                onPressed: () {},
                                              ),
                                      ));
                                      if (!isLogin)
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthScreen()),
                                            (route) => false);
                                    } else if (value.toString() ==
                                        'addedAfterDeletingCart') {
                                      setState(() {
                                        item.inCart = true;
                                        counter = 1;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor:
                                            Color(Constants.mainColor),
                                        content: Text(
                                          isLogin
                                              ? 'تم اضافة المنتج بنجاح.'
                                              : 'من فضلك قم بالتسجيل لاستكمال طلبك',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Tajawal'),
                                        ),
                                        action: isLogin
                                            ? SnackBarAction(
                                                label: 'الذهاب الي السلة',
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              CartScreen()));
                                                },
                                              )
                                            : SnackBarAction(
                                                label: '',
                                                onPressed: () {},
                                              ),
                                      ));
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 0.26.sh,
                                            child: item.image != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: item.count != 0
                                                        ? Image.network(
                                                            item.image,
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Stack(
                                                            children: [
                                                              Image.network(
                                                                item.image,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              Container(
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4),
                                                                child: Center(
                                                                  child: Text(
                                                                    'غير متوفر في الوقت الحالي',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: item.count != 0
                                                        ? Image.asset(
                                                            'assets/images/دون صوره.png',
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Stack(
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/دون صوره.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              Container(
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4),
                                                                child: Center(
                                                                  child: Text(
                                                                    'غير متوفر في الوقت الحالي',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              item.count != 0 &&
                                                      double.parse(
                                                              item.price) !=
                                                          0.0
                                                  ? Container(
                                                      height: 0.09.sw,
                                                      width: 0.09.sw,
                                                      margin: EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black12,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          if (!item.inCart) {
                                                            if (LocalStorage.getData(
                                                                        key:
                                                                            'vendor') ==
                                                                    null ||
                                                                LocalStorage.getData(
                                                                        key:
                                                                            'vendor') ==
                                                                    widget
                                                                        .shopId) {
                                                              setState(() {
                                                                item.inCart =
                                                                    true;
                                                              });
                                                              BlocProvider
                                                                      .of<CartCubit>(
                                                                          context)
                                                                  .addToCart(
                                                                      shopId: widget
                                                                          .shopId,
                                                                      productId:
                                                                          item
                                                                              .id,
                                                                      quantity:
                                                                          1,
                                                                      options: [],
                                                                      extras: []).then((value) {
                                                                setState(() {
                                                                  counter = LocalStorage
                                                                      .getData(
                                                                          key:
                                                                              'counter');
                                                                });
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  backgroundColor:
                                                                      Color(Constants
                                                                          .mainColor),
                                                                  content: Text(
                                                                    isLogin
                                                                        ? 'تم اضافة المنتج بنجاح.'
                                                                        : ' من فضلك قم بالتسجيل لاستكمال طلبك ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Tajawal'),
                                                                  ),
                                                                  action: isLogin
                                                                      ? SnackBarAction(
                                                                          label:
                                                                              'الذهاب الي السلة',
                                                                          textColor:
                                                                              Colors.white,
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CartScreen()));
                                                                          },
                                                                        )
                                                                      : SnackBarAction(
                                                                          label:
                                                                              '',
                                                                          onPressed:
                                                                              () {},
                                                                        ),
                                                                ));
                                                                if (!isLogin)
                                                                  Navigator.pushAndRemoveUntil(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              AuthScreen()),
                                                                      (route) =>
                                                                          false);
                                                              });
                                                            } else {
                                                              _showMyDialog(
                                                                      item.id)
                                                                  .then(
                                                                      (value) {
                                                                if (value) {
                                                                  setState(() {
                                                                    item.inCart =
                                                                        true;
                                                                  });
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    backgroundColor:
                                                                        Color(Constants
                                                                            .mainColor),
                                                                    content:
                                                                        Text(
                                                                      isLogin
                                                                          ? 'تم اضافة المنتج بنجاح.'
                                                                          : 'من فضلك قم بتسجيل الدخول لاستكمال طلبك',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'Tajawal'),
                                                                    ),
                                                                    action: isLogin
                                                                        ? SnackBarAction(
                                                                            label:
                                                                                'الذهاب الي السلة',
                                                                            textColor:
                                                                                Colors.white,
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => CartScreen()));
                                                                            },
                                                                          )
                                                                        : SnackBarAction(
                                                                            label:
                                                                                '',
                                                                            onPressed:
                                                                                () {},
                                                                          ),
                                                                  ));

                                                                  if (!isLogin)
                                                                    Navigator.pushAndRemoveUntil(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                AuthScreen()),
                                                                        (route) =>
                                                                            false);
                                                                }
                                                              });
                                                            }
                                                          } else {
                                                            setState(() {
                                                              item.inCart =
                                                                  false;
                                                            });
                                                            BlocProvider.of<
                                                                        CartCubit>(
                                                                    context)
                                                                .removeFromCart(
                                                                    productId:
                                                                        item.id,
                                                                    lastItem: counter ==
                                                                            1
                                                                        ? true
                                                                        : false)
                                                                .then((value) {
                                                              setState(() {
                                                                counter =
                                                                    LocalStorage
                                                                        .getData(
                                                                            key:
                                                                                'counter');
                                                              });
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                backgroundColor:
                                                                    Color(Constants
                                                                        .mainColor),
                                                                content: Text(
                                                                  'تم حذف المنتج بنجاح.',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Tajawal'),
                                                                ),
                                                                action: isLogin
                                                                    ? SnackBarAction(
                                                                        label:
                                                                            'الذهاب الي السلة',
                                                                        textColor:
                                                                            Colors.white,
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .push(MaterialPageRoute(builder: (_) => CartScreen()));
                                                                        },
                                                                      )
                                                                    : SnackBarAction(
                                                                        label:
                                                                            '',
                                                                        onPressed:
                                                                            () {},
                                                                      ),
                                                              ));
                                                            });
                                                          }
                                                        },
                                                        icon: Icon(
                                                          !item.inCart
                                                              ? Icons
                                                                  .add_shopping_cart
                                                              : Icons
                                                                  .shopping_cart,
                                                          color: Colors.green,
                                                          size: 22,
                                                        ),
                                                        splashRadius: 1,
                                                      ),
                                                    )
                                                  : Container(),
                                              Container(
                                                height: 0.09.sw,
                                                width: 0.09.sw,
                                                margin: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: IconButton(
                                                  onPressed: () {
                                                    if (LocalStorage.getData(
                                                                key: 'token') ==
                                                            null &&
                                                        LocalStorage.getData(
                                                                key: 'token') ==
                                                            '') {
                                                      _showDialog(context,
                                                          'لا يمكن الاضافه الي المفضلة يجب عليك التسجيل اولا');
                                                    } else {
                                                      BlocProvider.of<
                                                                  FavoritesCubit>(
                                                              context)
                                                          .toggleFavoriteStatus(
                                                              itemId: item.id,
                                                              vendorId:
                                                                  widget.shopId)
                                                          .then((value) =>
                                                              setState(() {
                                                                item.inFavourite =
                                                                    !item
                                                                        .inFavourite;
                                                              }));
                                                    }
                                                  },
                                                  icon: Icon(
                                                    item.inFavourite
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border_outlined,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                  splashRadius: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          double.parse(item.price) == 0.0
                                              ? Text(
                                                  'السعر يعتمد علي اختياراتك',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xff4A4B4D)),
                                                )
                                              : Text(
                                                  item.price.toString() +
                                                      " SR ",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff4A4B4D)),
                                                ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          item.beforeDiscount != "0.00" &&
                                                  double.parse(item.price) !=
                                                      0.0
                                              ? Stack(
                                                  children: [
                                                    Text(
                                                      'SR ${item.beforeDiscount}',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6),
                                                      child: Container(
                                                        height: 1,
                                                        width: 45,
                                                        color: Colors.black45,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Text(
                                          item.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                      // Center(
                                      //   child: Container(
                                      //     width: 150,
                                      //     height: 25,
                                      //     decoration: BoxDecoration(
                                      //         color: Colors.indigo,
                                      //         borderRadius: BorderRadius.all(
                                      //             Radius.circular(5))),
                                      //     child: InkWell(
                                      //       onTap: () {
                                      //         BlocProvider.of<CartCubit>(
                                      //                 context)
                                      //             .addToCart(
                                      //                 shopId: widget.shopId,
                                      //                 productId: item.id,
                                      //                 quantity: 1,
                                      //                 options: [],
                                      //                 extras: []).then((value) {
                                      //           setState(() {
                                      //             counter =
                                      //                 LocalStorage.getData(
                                      //                     key: 'counter');
                                      //           });
                                      //           ScaffoldMessenger.of(context)
                                      //               .showSnackBar(SnackBar(
                                      //             backgroundColor: Color(
                                      //                 Constants.mainColor),
                                      //             content: Text(
                                      //               'تم اضافة المنتج الي السلة بنجاح.',
                                      //               style:
                                      //                   TextStyle(fontSize: 14),
                                      //             ),
                                      //             action: SnackBarAction(
                                      //               label: 'الذهاب الي السلة',
                                      //               textColor: Colors.white,
                                      //               onPressed: () {
                                      //                 Navigator.of(context).push(
                                      //                     MaterialPageRoute(
                                      //                         builder: (_) =>
                                      //                             CartScreen()));
                                      //               },
                                      //             ),
                                      //           ));
                                      //         });
                                      //       },
                                      //       child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         children: [
                                      //           Text(
                                      //             'اضافة الى السلة',
                                      //             style: TextStyle(
                                      //                 color: Colors.white,
                                      //                 fontSize: 14),
                                      //           ),
                                      //           SizedBox(
                                      //             width: 5,
                                      //           ),
                                      //           Icon(
                                      //             Icons.add_shopping_cart,
                                      //             color: Colors.white,
                                      //             size: 18,
                                      //           )
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              );
                            }

                            // => BuildItem(
                            //   title: item.name,
                            //   image: item.image,
                            //   isFav: item.inFavourite == 1 ? true : false,
                            //   itemId: item.id,
                            //   beforeDiscount: item.beforeDiscount,
                            //   price: item.price,
                            //   shopId: widget.shopId,
                            // ),
                            ),
                      ),
              )
            ],
          ),
        ));
  }

  _showDialog(BuildContext context, String title) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AuthScreen())),
          // code on continue comes here
        };
    BlurryDialog alert = BlurryDialog('التسجيل اولا', title, continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
