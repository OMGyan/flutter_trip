import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview.dart';

const PAGE_SIZE = 10;
const _TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
class TravelTabPage extends StatefulWidget{
  final String travelUrl;
  final String groupChannelCode;
  final Map params;

  const TravelTabPage({Key key, this.travelUrl, this.groupChannelCode, this.params}) : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();

}

class _TravelTabPageState extends State<TravelTabPage>with AutomaticKeepAliveClientMixin{

  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading = true;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    _loadData();
    ///监听列表滚动
    _controller.addListener((){
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        _loadData(loadmore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body:LoadingContainer(isLoading: _loading,
          child: RefreshIndicator(child:MediaQuery.removePadding(context: context,removeTop: true,
              child: StaggeredGridView.countBuilder(
                controller: _controller,
                crossAxisCount: 2,
                itemCount: travelItems?.length??0,
                itemBuilder: (BuildContext context, int index) => _travelItem(index: index,item: travelItems[index]),
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.fit(1),
              )),onRefresh:_handleRefresh)));
  }

  void _loadData({loadmore = false}) {
    if(loadmore){
      pageIndex++;
    }else{
      pageIndex = 1;
    }

    TravelDao.fetch(widget.travelUrl??_TRAVEL_URL,widget.params,widget.groupChannelCode, pageIndex,PAGE_SIZE).then((value){
      _loading = false;
      setState(() {
        List<TravelItem> items = _filterItems(value.resultList);
        if(travelItems!=null){
          travelItems.addAll(items);
        }else{
          travelItems = items;
        }
      });
    }).catchError((e){
      _loading = false;
      print(e.toString());
    });
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if(resultList==null){
      return [];
    }
    List<TravelItem> filterItems = [];
    resultList.forEach((element) {
      if(element.article!=null){
        filterItems.add(element);
      }
    });
    return filterItems;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



  Future<void> _handleRefresh() async{
    _loadData();
    return null;
  }
}

class _travelItem extends StatelessWidget{

  final int index;
  final TravelItem item;

  const _travelItem({Key key, this.index, this.item}) : super(key: key);

  get _itemImage{
     return Stack(
       children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
         Positioned(child: Container(
           padding: EdgeInsets.fromLTRB(5,1,5,1),
           decoration: BoxDecoration(
             color: Colors.black54,
             borderRadius: BorderRadius.circular(10)
           ),child: Row(
           children: <Widget>[
             Padding(padding: EdgeInsets.only(right: 3),
             child: Icon(Icons.location_on,color: Colors.white,size: 12),
             ), LimitedBox(maxWidth:130,child:
             Text(_poiName(),overflow: TextOverflow.ellipsis,maxLines: 1,
                 style: TextStyle(color: Colors.white,fontSize: 12)))
           ],
         ),
         ),bottom: 8,left: 8)
       ]
     );
  }

  get _infoText{
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.article.author?.coverImage?.dynamicUrl,
                  width: 24,
                  height: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  item.article.likeCount.toString(),
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String _poiName() {
    return item.article.pois == null || item.article.pois.length == 0
        ? '未知'
        : item.article.pois[0]?.poiName ?? '未知';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        if(item.article.urls!=null && item.article.urls.length>0){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            return WebView( url:item.article.urls[0].h5Url);
          }));
        }
      },child: Card(
      child: PhysicalModel(color: Colors.transparent,clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _itemImage,
            Container(
              padding: EdgeInsets.all(4),
              child: Text(item.article.articleTitle,maxLines: 2,
              overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,color: Colors.black87
                ),
              ),
            ),
            _infoText
          ],
        )
      )
    ),
    );
  }
}