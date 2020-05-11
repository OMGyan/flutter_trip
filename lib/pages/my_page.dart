import 'package:flutter/material.dart';

class MyPage extends StatefulWidget{
  @override
  _MyPageState createState() => _MyPageState();

}

class _MyPageState extends State<MyPage>with AutomaticKeepAliveClientMixin{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Center(
        child: Text('我的')
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}