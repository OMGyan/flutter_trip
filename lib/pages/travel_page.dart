import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_tab_dao.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:flutter_trip/pages/travel_tab_page.dart';

class TravelPage extends StatefulWidget{
  @override
  _TravelPageState createState() => _TravelPageState();
}
class _TravelPageState extends State<TravelPage>with TickerProviderStateMixin,AutomaticKeepAliveClientMixin{

  TabController _controller;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
     TravelTabDao.fetch().then((TravelTabModel model){
       _controller = TabController(length: model.tabs.length, vsync: this);
       setState(() {
         tabs = model.tabs;
         travelTabModel = model;
       });
     }).catchError((e){
       print(e.toString());
     });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body:Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: TabBar(tabs:tabs.map<Tab>((e){
              return Tab(text:e.labelName);
            }).toList(),controller: _controller,isScrollable: true,labelColor: Color(0xff2fcfbb),unselectedLabelColor:Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20,0,10,5),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Color(0xff2fcfbb),width: 3),
              //insets: EdgeInsets.only(bottom: 10)
            ),),),Flexible(child: TabBarView(children: tabs.map((e){
            return TravelTabPage(travelUrl: travelTabModel.url,groupChannelCode: e.groupChannelCode,params: travelTabModel.params);
          }).toList(),controller: _controller))
        ],
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}