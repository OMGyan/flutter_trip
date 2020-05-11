import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget{


  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;
  final bool backForbid;


  WebView({this.title, this.url, this.statusBarColor, this.hideAppBar, this.backForbid = false});

  @override
  _WebViewState createState()=>_WebViewState();

}

class _WebViewState extends State<WebView>{
  List<String> mainUrl = ['https://m.ctrip.com/html5/','https://m.ctrip.com/webapp/you/','https://m.ctrip.com/html5/you/'];
  final webviewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChange;
  StreamSubscription<WebViewStateChanged> _onStateChange;
  StreamSubscription<WebViewHttpError> _onHttpError;

  bool isExit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webviewReference.close();
    _onUrlChange = webviewReference.onUrlChanged.listen((url){

    });



    _onStateChange = webviewReference.onStateChanged.listen((state){
      switch(state.type){
        case WebViewState.startLoad:
            if(isContainMain(state.url)&&!isExit){
              if(widget.title == '当地攻略'){
                if(state.url=='https://m.ctrip.com/html5/you/'){
                  Navigator.of(context).pop();
                  isExit = true;
                }
              }else{
                if(!widget.backForbid){
                  Navigator.of(context).pop();
                  isExit = true;
                }
              }
            }
          break;
        case WebViewState.abortLoad:
          break;
        case WebViewState.finishLoad:
          break;
        case WebViewState.shouldStart:
          break;
      }

    });
    _onHttpError = webviewReference.onHttpError.listen((error){
      print(error.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onUrlChange.cancel();
    _onStateChange.cancel();
    _onHttpError.cancel();
    webviewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor = statusBarColorStr == 'ffffff'?Colors.black:Colors.white;
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff'+statusBarColorStr)),backButtonColor),
          Expanded(child: WebviewScaffold(url: widget.url,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: Center(
                child: Text('Waiting...'),
              ),
            ),
          ),)
        ],
      ),
    );
  }

  _appBar(Color backgroundColor,Color backButtonColor) {
    return Container(
      color: backgroundColor,
      height:MediaQueryData.fromWindow(window).padding.top,
    );
    if(widget.hideAppBar??false){
      return Container(
        color: backgroundColor,
        height:MediaQueryData.fromWindow(window).padding.top,
      );
    }
    return Container(
      color: backgroundColor,
      padding:EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.close,color: backButtonColor,size: 26)
              ),onTap: (){
                Navigator.of(context).pop();},
            ),
            Positioned(child: Center(
              child: Text(widget.title??'',style: TextStyle(color: backButtonColor,fontSize: 20))
            ),left: 0,right: 0)
          ],
        ),

      ),
    );

  }

  bool isContainMain(String url) {
      bool contain = false;
      for(var e in mainUrl){
          if(url?.endsWith(e) ?? false){
              contain = true;
              break;
          }
      }
      return contain;
  }

}