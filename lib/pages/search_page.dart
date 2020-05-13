

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/webview.dart';

const searchBarDefaultText = '网红打卡地 景点 酒店 美食';

class SearchPage extends StatefulWidget{

  final bool hideLeft;
  final String hint;

  const SearchPage({Key key,this.hideLeft = true, this.hint = searchBarDefaultText}) : super(key: key);



  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage>{
   SearchModel searchModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(children: <Widget>[
        _appBar,
         MediaQuery.removePadding(context: context, child:
         Expanded(child:ListView.builder(itemBuilder: (ctx,index){
               return _item(index);},
             itemCount: searchModel?.data?.length??0)),
           removeTop: true,
         )
      ],)
    );
  }

   get _appBar{
     return Column(children: <Widget>[
       Container(
           decoration: BoxDecoration(
               gradient: LinearGradient(
                 //appbar渐变遮罩背景
                   colors: [Color(0x66000000),Colors.transparent],
                   begin: Alignment.topCenter,
                   end: Alignment.bottomCenter
               )
           ),
         child: Container(
           padding: EdgeInsets.only(top: 20),
           height: 80,
           decoration: BoxDecoration(color: Colors.white),
           child:SearchBar(hideLeft:widget.hideLeft,hint: widget.hint,
             onChange: _onTextChange,leftBtnClick:(){
                 Navigator.pop(context);
             },
           )
         )
       )
     ]);
   }

  _onTextChange(String value) {
     if(value.length==0){
       setState(() {
         searchModel = null;
       });
       return;
     }
     SearchDao.fetch(value).then((SearchModel res) {
       if(res.keyword==value){
         setState(() {
           searchModel = res;
         });
       }
     }).catchError((e){
          print(e);
     });
  }

  _item(int index) {
     if(searchModel==null||searchModel.data==null)return null;
     SearchItem item = searchModel.data[index];
     return _itemView(item);
  }

  _itemView(SearchItem item){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
          return WebView(url:item.url,);
        }));
      },child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3,color: Colors.grey))
      ),child: Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 300,child: Text('${item.word} ${item.districtName} ${item.zoneName}'),
            ),
            Container(
              width: 300,child: Text('${item.price} ${item.type}'),
            )],)],),),);}
}