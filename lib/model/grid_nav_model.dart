import 'common_model.dart';

class GridNavModel{

  GridNavItem hotel;
  GridNavItem flight;
  GridNavItem travel;

  GridNavModel({this.hotel, this.flight, this.travel});

  GridNavModel.fromJson(Map<String, dynamic> json) {
     hotel = GridNavItem.fromJson(json['hotel']);
     flight = GridNavItem.fromJson(json['flight']);
     travel = GridNavItem.fromJson(json['travel']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.hotel != null) {
      data['hotel'] = this.hotel;
    }
    if (this.flight != null) {
      data['flight'] = this.flight;
    }
    if (this.travel != null) {
      data['travel'] = this.travel;
    }

    return data;
  }
}

class GridNavItem{

   String startColor;
   String endColor;
   CommonModel mainItem;
   CommonModel item1;
   CommonModel item2;
   CommonModel item3;
   CommonModel item4;

  GridNavItem({this.startColor, this.endColor, this.mainItem, this.item1,
      this.item2, this.item3, this.item4});

  GridNavItem.fromJson(Map<String, dynamic> json) {
    startColor = json['startColor'];
    endColor = json['endColor'];
    mainItem = CommonModel.fromJson(json['mainItem']);
    item1 = CommonModel.fromJson(json['item1']);
    item2 = CommonModel.fromJson(json['item2']);
    item3 = CommonModel.fromJson(json['item3']);
    item4 = CommonModel.fromJson(json['item4']);
  }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['startColor'] = this.startColor;
     data['endColor'] = this.endColor;
     data['mainItem'] = this.mainItem;
     data['item1'] = this.item1;
     data['item2'] = this.item2;
     data['item3'] = this.item3;
     data['item4'] = this.item4;
     return data;
   }
}