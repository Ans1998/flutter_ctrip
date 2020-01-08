import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';

// import 'package:flutter_trip/dao/home_dao.dart';
// import 'package:flutter_trip/model/home_model.dart';
// import 'package:flutter_trip/model/common_model.dart';

import './../../dao/home_dao.dart';
import './../../model/home_model.dart';
import './../../model/common_model.dart';

// 模版组件
// import 'package:flutter_trip/widget/component_template.dart';
// import './../../widget/grid_nav.dart';

// 导航栏
// import 'package:flutter_trip/widget/local_nav.dart';
import './../../widget/loacl_nav.dart';

// 网格
import './../../widget/grid_nav.dart';
import './../../model/grid_nav_model.dart';

// 活动入口
// import 'package:flutter_trip/widget/sub_nav.dart';
import './../../widget/sub_nav.dart';

// 底部卡片
import './../../model/sales_box_model.dart';
import './../../widget/sales_box.dart';

// 加载动画
import './../../widget/loading_container.dart';
import './../../widget/webView.dart';

// 搜索
import './../../widget/search_bar.dart';
import './../search/index.dart';

// 语音
import './../speak/index.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List _imageUrls = [
  //   'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
  //   'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
  //   'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  // ];
  double appBarAlpha = 0;
  String resultString = "";
  List<CommonModel> localNavList = [];
  GridNavModel gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBoxModel;
  List<CommonModel> bannerList = [];
  bool _loading = true;


  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    // print(appBarAlpha);
  }
  // 网络请求
  loadData() async {
  //    HomeDao.fetch().then((result) {
  //      setState(() {
  //        resultString = json.encode(result);
  //      });
  //    }).catchError((e) {
  //      setState(() {
  //        resultString = e.toString();
  //      });
  //    });
    try {
      HomeModel model = await HomeDao.ferch();
      setState(() {
        // resultString = json.encode(model.config);
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
      });
      // print(localNavList);
    } catch (e) {
      print(e);
      // setState(() {
      //   resultString = e.toString();
      // });
    }
  }
  // 网络请求
  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.ferch();
      setState(() {
        // resultString = json.encode(model.config);
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
      // print(localNavList);
    } catch (e) {
      print(e);
      setState(() {
       _loading = false;
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    print("---发起网络请求---");
    // this.loadData();
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body:  LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: NotificationListener(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification &&
                            scrollNotification.depth == 0) {
                          //滚动且是列表滚动的时候
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                      },
                      child: _listView,
                    )),
              ),
              _appBar
            ],
          )),
       );
  }
  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        // 模版组件
        // Padding(
        //   child: ComponentTemplate(),
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(gridNavModel: gridNavModel)),
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(subNavList: subNavList)),
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(salesBox: salesBoxModel)),
      ],
    );
  }
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(

          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),

        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)])
        )

      ],
    );
  }

  _jumpToSearch() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT,);
    }));
  }
  _jumpToSpeak() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SpeakPage()));
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  CommonModel model = bannerList[index];
                  return WebView(
                      url: model.url,
                      title: model.title,
                      hideAppBar: model.hideAppBar);
                }),
              );
            },
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }
}