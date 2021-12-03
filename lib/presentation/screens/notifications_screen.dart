import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:toot/constants.dart';
import 'package:toot/data/models/offer.dart';
import 'package:toot/data/web_services/product_web_service.dart';
import 'package:toot/presentation/screens/single_notification_screen.dart';
import 'package:toot/presentation/widgets/buttom_nav_bar.dart';
import 'package:toot/presentation/widgets/customised_appbar.dart';

class NotificationScreen extends StatefulWidget {
  static const _pageSize = 5;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  late TabController tabController;

  Future<void> _fetchPage(context, int pageKey) async {
    try {
      final rawData = await ProductWebServices().fetchOffers(pageKey);
      List newItems = rawData.map((offer) => Offer.fromJson(offer)).toList();
      print(newItems.length);
      final isLastPage = newItems.length < NotificationScreen._pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems, 'no');
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey, 'no');
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(context, pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BuildAppBar(
          title: 'تنبيهات',
        ),
        body:
            // ? Column(
            //     children: [
            //       Center(
            //         child: Lottie.asset('assets/images/78616-notification.json',
            //             height: 500),
            //       ),
            //       Text(
            //         'لا يوجد تنبيهات',
            //         style: TextStyle(fontSize: 24.sp),
            //       ),
            //     ],
            //   )
            PagedGridView<int, dynamic>(
          // showNewPageProgressIndicatorAsGridChild: false,
          // showNewPageErrorIndicatorAsGridChild: false,
          showNoMoreItemsIndicatorAsGridChild: false,
          pagingController: _pagingController,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 70),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 1.3),
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
              firstPageProgressIndicatorBuilder: (_) {
                return Container(
                  height: 0.8.sh,
                  child: Center(
                      child: Container(
                    height: 120,
                    width: 120,
                    child: Lottie.asset('assets/images/lf20_j1klguuo.json'),
                  )),
                );
              },
              noItemsFoundIndicatorBuilder: (_) {
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Center(
                      child: Lottie.asset(
                          'assets/images/78616-notification.json',
                          height: 200),
                    ),
                    Text(
                      'لا يوجد تنبيهات',
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ],
                );
              },
              itemBuilder: (context, item, index) => Column(
                    children: [
                      BuildNotificationItem(
                        title: item.title,
                        image: item.image,
                        details: item.description ?? '',
                        id: item.id,
                      ),
                    ],
                  )),
        ));
  }
}

class BuildNotificationItem extends StatelessWidget {
  final String title;
  final String details;
  final String image;
  final int id;

  BuildNotificationItem(
      {required this.title,
      required this.image,
      required this.details,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SingleNotificationScreen(
                    id: id,
                    details: details,
                    title: title,
                    image: image,
                  )));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: image != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        child: Image.network(
                          image,
                          width: 1.sw,
                          height: 200,
                          fit: BoxFit.fill,
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        child: Image.asset(
                          "assets/images/دون صوره.png",
                          width: 1.sw,
                          height: 200,
                          fit: BoxFit.fill,
                        )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Color(Constants.mainColor),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 10, 5),
                    child: Text(
                      details,
                      maxLines: 1,
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
