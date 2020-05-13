import 'dart:async';
import 'dart:convert';
import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_trip/model/home_model.dart';

const SEARCH_URL = 'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';
///搜索接口
class SearchDao{
  static Future<SearchModel> fetch(key) async {
     final response = await http.get(SEARCH_URL+key);
     if(response.statusCode == 200){
       Utf8Decoder utf8decoder = Utf8Decoder();//修复中文乱码问题
       var result = json.decode(utf8decoder.convert(response.bodyBytes));
       SearchModel model = SearchModel.fromJson(result);
       //当服务端的key与搜索的key相同时才渲染
       model.keyword = key;
       return model;
     }else{
       throw Exception('Failed to load search.json');
     }
  }
}