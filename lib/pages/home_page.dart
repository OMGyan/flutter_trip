import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/widget/local_nav.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  String data = '';
  
  List<CommonModel> localNavList;
  double appBarAlpha = 0;
  final APPBAR_SCROLL_OFFSET = 100;

  List _imageUrls = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(children: <Widget>[
        MediaQuery.removePadding(context: context,
            removeTop: true,
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
                    child: Swiper(itemCount: _imageUrls.length,autoplay: true,itemBuilder: (ctx,index){
                      return Image.network(_imageUrls[index],fit: BoxFit.fill);
                    },pagination: SwiperPagination()),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5, 4, 5, 4)
                  ,child:LocalNav(localNavList: localNavList)
                  ),
                  Container(
                      child: ListTile(title: Text(data))
                  )
                ]
            )
            )
        ),
        Opacity(child:Container(
          height: 75,
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20),
          child: Text('首页')
        ),opacity: appBarAlpha)
      ])
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

  void loadData() {
    HomeDao.fetch().then((HomeModel res){
      setState(() {
        data = jsonEncode(res);
        localNavList = res.localNavList;
      });
    }).catchError((e){
      setState(() {
        print(e.toString());
      });
    });
  }

}