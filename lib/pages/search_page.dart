import 'package:flutter/material.dart';
import 'package:flutter_trip/widget/search_bar.dart';

class SearchPage extends StatefulWidget{
  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage>with AutomaticKeepAliveClientMixin{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body:Column(children: <Widget>[
        SearchBar(hideLeft: true,defaultText: '哈哈',hint: '123',
        leftBtnClick: (){Navigator.of(context).pop();},
          onChange: _onTextChange,
        )
      ],)
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  _onTextChange(String value) {

  }
}