import 'common_model.dart';
import 'config_model.dart';
import 'grid_nav_model.dart';
import 'sales_box_model.dart';

class HomeModel{
    ConfigModel config;
    List<CommonModel> bannerList;
    List<CommonModel> localNavList;
    GridNavModel gridNav;
    List<CommonModel> subNavList;
    SalesBoxModel salesBox;

   HomeModel({this.config, this.bannerList, this.localNavList, this.gridNav,
       this.subNavList, this.salesBox});


   HomeModel.fromJson(Map<String, dynamic> json) {
     var localNavListJson = json['localNavList'] as List;
     List<CommonModel> localNavList =
     localNavListJson.map((i) => CommonModel.fromJson(i)).toList();

     var bannerListJson = json['bannerList'] as List;
     List<CommonModel> bannerList =
         bannerListJson.map((i)=>CommonModel.fromJson(i)).toList();

     var subNavListJson = json['subNavList'] as List;
     List<CommonModel> subNavList =
         subNavListJson.map((i)=>CommonModel.fromJson(i)).toList();


         config= ConfigModel.fromJson(json['config']);
         this.bannerList= bannerList;
         this.subNavList= subNavList;
         this.localNavList= localNavList;
         gridNav= GridNavModel.fromJson(json['gridNav']);
         salesBox= SalesBoxModel.fromJson(json['salesBox']);

   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['config'] = this.config;
     data['gridNav'] = this.gridNav;
     data['salesBox'] = this.salesBox;
     data['localNavList'] = this.localNavList;
     data['bannerList'] = this.bannerList;
     data['subNavList'] = this.subNavList;
     return data;
   }
}