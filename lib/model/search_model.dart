class SearchModel{

  String keyword;

  List<SearchItem> data;

  SearchModel({this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SearchItem>();
      json['data'].forEach((v) {
        data.add(new SearchItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class SearchItem{
  String word;
  String type;
  String districtName;
  String url;
  String price;
  String star;
  String zoneName;

  SearchItem({this.word, this.type, this.districtName, this.url, this.price,
    this.star, this.zoneName});

  SearchItem.fromJson(Map<String, dynamic> json) {
    word = json['word']??'';
    type = json['type']??'';
    districtName = json['districtname']??'';
    url = json['url']??'';
    price = json['price']??'';
    star = json['star']??'';
    zoneName = json['zonename']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['type'] = this.type;
    data['districtname'] = this.districtName;
    data['url'] = this.url;
    data['price'] = this.price;
    data['star'] = this.star;
    data['zonename'] = this.zoneName;
    return data;
  }

}