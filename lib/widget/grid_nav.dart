

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview.dart';

/**
 * 网格布局
 */
class GridNav extends StatelessWidget{

  final GridNavModel gridNavModel;

  const GridNav({Key key,@required this.gridNavModel} ):super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children:_gridNavItems(context)
    );
  }

  _gridNavItems(BuildContext context){
    List<Widget> items = [];
    if(gridNavModel == null) return items;
    if(gridNavModel.hotel!=null){
       items.add(_gridNavItem(context,gridNavModel.hotel,true));
    }
    if(gridNavModel.flight!=null){
      items.add(_gridNavItem(context,gridNavModel.flight,false));
    }
    if(gridNavModel.travel!=null){
      items.add(_gridNavItem(context,gridNavModel.travel,false));
    }
    return items;
  }
  _gridNavItem(BuildContext context,GridNavItem gridNavItem,bool first){
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context,gridNavItem.item1,gridNavItem.item2));
    items.add(_doubleItem(context,gridNavItem.item3,gridNavItem.item4));
    Color startColor = Color(int.parse('0xff'+gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff'+gridNavItem.endColor));
    return Container(
      height: 88,
      margin: first?null:EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        //线性渐变
        gradient: LinearGradient(colors: [startColor,endColor])
      ),
      child: Row(children: items)
    );
  }
  _mainItem(BuildContext context,CommonModel model){
    return Expanded(child: _wrapGesture(context,
        Stack(
          children: <Widget>[
            Image.network(model.icon,fit: BoxFit.contain,height: 88,width: 121,alignment: AlignmentDirectional.bottomEnd),
            Text(model.title,style: TextStyle(fontSize: 14,color: Colors.white))
          ],
        ),model
    ),flex: 1);
  }

  _doubleItem(BuildContext context,CommonModel topItem,CommonModel bottomItem){
    return Expanded(child: Column(
      children: <Widget>[
        Expanded(child: _item(context,topItem,true)),
        Expanded(child: _item(context,bottomItem,false))
      ],
    ),flex: 1) ;
  }

  _item(BuildContext context,CommonModel item,bool isFirstItem){
    BorderSide borderSide = BorderSide(width: 0.8,color: Colors.white);
    return FractionallySizedBox(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
             left: borderSide,
            bottom: isFirstItem?borderSide:BorderSide.none
          )
        ),
        child: _wrapGesture(context,Center(
            child: Text(item.title,textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.white))
        ), item)
      ),
    );
  }

  _wrapGesture(BuildContext context,Widget widget,CommonModel model){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
              return WebView(title: model.title,url: model.url,statusBarColor: model.statusBarColor,hideAppBar: model.hideAppBar);
            }));
      },

    );
  }
}