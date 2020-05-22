

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/webview.dart';

const searchBarDefaultText = '网红打卡地 景点 酒店 美食';
const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
class SearchPage extends StatefulWidget{

  final bool hideLeft;
  final String hint;
  final String keyword;
  const SearchPage({Key key,this.hideLeft = true, this.hint = searchBarDefaultText, this.keyword}) : super(key: key);



  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage>{
   SearchModel searchModel;
   var keyword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(children: <Widget>[
        _appBar,
         MediaQuery.removePadding(context: context, child:
         Expanded(child:ListView.builder(itemBuilder: (ctx,index){
               return _item(index);},
             itemCount:searchModel?.data?.length??0)),
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
             onChange:_onTextChange,defaultText:widget.keyword,leftBtnClick:(){
                 Navigator.pop(context);
             },speakClick: (){
               Navigator.of(context).push(MaterialPageRoute(
                 builder: (ctx) => SpeakPage()
               ));
             },
           )
         )
       )
     ]);
   }

  _onTextChange(String value) {
     keyword = value;
     if(value.length==0){
       setState(() {
         searchModel = null;
       });
       return;
     }
     SearchDao.fetch(keyword).then((SearchModel res) {
       if(res.keyword==keyword){
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
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3,color: Colors.grey))
      ),child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          Container(
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 7, 7,0),
                child:Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)))),
          ), Container(
            width: 300,child:_title(item),
          )
        ]),
        Container(
          margin: EdgeInsets.fromLTRB(25, 5, 0, 5),
          width: 300,child:_subTitle(item),
        )],),),);}

   _typeImage(String type){
    if(type == null)return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for (var value in TYPES) {
      if(type.contains(value)){
        path = value;
        break;
      }
    }
    return 'images/type_$path.png';
   }

   _title(SearchItem item){
    if(item == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_ketWordTextSpan(item.word,searchModel.keyword));
    spans.add(TextSpan(text: ' '+item.districtName+' '+item.zoneName,
    style: TextStyle(fontSize: 16,color: Colors.grey)
    ));
    return RichText(text: TextSpan(children: spans),overflow: TextOverflow.ellipsis,);
   }

   _subTitle(SearchItem item){
    return RichText(text: TextSpan(children: <TextSpan>[
      TextSpan(
        text: item.price,
        style: TextStyle(fontSize: 16,color: Colors.orange)
      ),

      TextSpan(
          text: ' '+item.star,
          style: TextStyle(fontSize: 12,color: Colors.grey)
      ),
    ]));


   }

   _ketWordTextSpan(String word, String keyword) {
     List<TextSpan> spans = [];
     if(word == null || word.length == 0) return spans;
     List<String> arr = word.split(keyword);
     TextStyle normalStyle = TextStyle(fontSize: 16,color: Colors.black87);
     TextStyle keyWordStyle = TextStyle(fontSize: 16,color: Colors.orange);
      for (int i = 0; i <arr.length; i++) {
        if((i+1)%2 == 0){
          spans.add(TextSpan(text: keyword,style: keyWordStyle));
        }
        var value = arr[i];
        if(value != null && value.length > 0){
          spans.add(TextSpan(text: value,style: normalStyle));
        }
      }
      return spans;
   }
}