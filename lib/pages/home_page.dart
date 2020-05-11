import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>with AutomaticKeepAliveClientMixin{
  String data = 'result';
  
  List<CommonModel> localNavList=[];
  List<CommonModel> bannerList=[];
  GridNavModel gridNavModel=null;
  List<CommonModel> subNavList=[];
  SalesBoxModel salesBox=null;
  double appBarAlpha = 0;
  bool _loading = true;

  final APPBAR_SCROLL_OFFSET = 100;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body:LoadingContainer(isLoading:_loading,child:
      Stack(children: <Widget>[
        MediaQuery.removePadding(context: context,
            removeTop: true,
            child:RefreshIndicator(onRefresh:_refreshData,
                child:NotificationListener<ScrollUpdateNotification>(
                onNotification: (scrollNotification){
                  if(scrollNotification.depth == 0){
                    //列表滚动时候
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return true;
                },child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Swiper(itemCount: bannerList.length,autoplay: true,itemBuilder: (ctx,index){
                      return GestureDetector(
                          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                         return WebView(title: bannerList[index].title,url:bannerList[index].url,
                                       statusBarColor:bannerList[index].statusBarColor,
                                        hideAppBar:bannerList[index].hideAppBar);
                          }));},child:Image.network(bannerList[index].icon,fit: BoxFit.fill));
                    },pagination: SwiperPagination()),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5, 4, 5, 4)
                      ,child:LocalNav(localNavList: localNavList)
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5,0,5,4),
                      child:GridNav(gridNavModel: gridNavModel)
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5,0,5,4),
                    child: SubNav(SubNavList: subNavList),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5,0,5,4),
                    child: SalesBox(salesBox: salesBox),
                  )])
            ))
        ),
        Opacity(child:Container(
            height: 75,
            color: Colors.white,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20),
            child: Text('首页')
        ),opacity: appBarAlpha)
      ])
      )
    );
  }

  void _onScroll(double pixels) {
    double alpha = pixels/APPBAR_SCROLL_OFFSET;
    if(alpha<0){
      alpha = 0;
    }else if(alpha > 1){
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Future<Null> _refreshData() async {
    HomeDao.fetch().then((HomeModel res){
      setState(() {
        localNavList = res.localNavList;
        gridNavModel = res.gridNav;
        subNavList = res.subNavList;
        salesBox = res.salesBox;
        bannerList = res.bannerList;
        _loading = false;
      });
    }).catchError((e){
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}