import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';

import 'webview.dart';


//底部卡片路口
class SalesBox extends StatelessWidget{

  final SalesBoxModel salesBox;

  const SalesBox({Key key,@required this.salesBox}):super(key:key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Colors.white,
      ),child:_items(context)
    );
  }

  _items(BuildContext context) {
    if(salesBox == null) return null;
    List<Widget> items = [];
    items.add(_doubleItem(context, salesBox.bigCard1, salesBox.bigCard2,true, false));
    items.add(_doubleItem(context, salesBox.smallCard1, salesBox.smallCard2,false, false));
    items.add(_doubleItem(context, salesBox.smallCard3, salesBox.smallCard4,false, true));

    return Column(children: <Widget>[
      Container(
        height: 44,
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1,color: Color(0xfff2f2f2)))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.network(salesBox.icon,fit: BoxFit.fill,height: 15),
            Container(
              padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(colors: [Color(0xffff4e63),Color(0xffff6cc9)])
              ),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context){
                      return WebView(url: salesBox.moreUrl,title: '更多活动');
                    }
                  ));
                },child: Text('获取更多福利 >',style: TextStyle(color: Colors.white,fontSize: 12))
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.sublist(0,1),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.sublist(1,2),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.sublist(2,3),
      )
    ]);
  }

  Widget _doubleItem(BuildContext context, CommonModel leftCard,CommonModel rightCard,bool isBigCard,bool isLastCard){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[_item(context, leftCard,true, isBigCard,isLastCard),
        _item(context, rightCard,false, isBigCard,isLastCard)],
    );
  }

  Widget _item(BuildContext context, CommonModel model,bool isleft, bool isBigCard,bool isLast) {
    BorderSide borderSide = BorderSide(width: 0.8,color: Color(0xfff2f2f2));
    return GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            return WebView(title: model.title,url: model.url,statusBarColor: model.statusBarColor,
                hideAppBar: model.hideAppBar);
          }));
        },child:Container(child: Image.network(model.icon,
        width:MediaQuery.of(context).size.width/2-10,height: isBigCard?129:80,fit: BoxFit.contain),
        decoration: BoxDecoration(
        border: Border(right: isleft?borderSide:BorderSide.none,bottom: isLast?BorderSide.none:borderSide)),
    )
    );
  }
}