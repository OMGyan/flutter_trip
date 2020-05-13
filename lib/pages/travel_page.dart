import 'package:flutter/material.dart';

class TravelPage extends StatefulWidget{
  @override
  _TravelPageState createState() => _TravelPageState();

}

class _TravelPageState extends State<TravelPage>with AutomaticKeepAliveClientMixin{


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body:Center(
        child: Text('旅拍')
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}