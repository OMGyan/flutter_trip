import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/plugin/asr_manager.dart';

///语音识别页面
class SpeakPage extends StatefulWidget{
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage> with SingleTickerProviderStateMixin{
  String speakTips = '长按说话';
  String speakResult = '';
  Animation<double> animation;
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn)
    ..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        animationController.reverse();
      }else if(status == AnimationStatus.dismissed){
        animationController.forward();
      }
    })
    ;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _topItem(),
              _bottomItem()
            ],
          ),
        ),
      )
    );
  }
  _speakStart(){
    animationController.forward();
    setState(() {
      speakTips = '- 识别中 -';
    });
    AsrManager.start().then((value){
      if(value!=null&&value.length>0){
        setState(() {
          speakResult = value;
        });
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx){
            return SearchPage(keyword: value);
          }
        ));
      }
    }).catchError((e){
      print("------------"+e.toString());
    });
  }
  _speakStop(){
    animationController.reset();
    animationController.stop();
    setState(() {
      speakTips = '长按说话';
    });
    AsrManager.stop();
  }
  _topItem() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(0,30,0,30),
        child:  Text('你可以这样说',
        style: TextStyle(fontSize: 16, color: Colors.black54))),
        Text('故宫门票\n北京一日游\n迪士尼乐园', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15,
            color: Colors.grey,
            )),
         Padding(padding: EdgeInsets.all(20),child: Text(speakResult,style: TextStyle(color: Colors.blue),))
      ],
    );
  }

  _bottomItem(){
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e){
              _speakStart();
            },
            onTapUp: (e){
              _speakStop();
            },
            onTapCancel: (){
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(10),child: Text(speakTips,style: TextStyle(color: Colors.cyanAccent,
                  fontSize: 12),)),
                  Stack(
                    children: <Widget>[
                      Container(
                        width: MIC_SIZE,
                        height: MIC_SIZE,
                      ),Center(
                        child: AnimatedMic(
                          animation: animation
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(child: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },child: Icon(Icons.close,color: Colors.grey,size: 30)
          ),right: 0,bottom: 20)
        ],
      ),
    );
  }


}
const double MIC_SIZE = 80;
class AnimatedMic extends AnimatedWidget{

  static final _opacityTween = Tween<double>(begin: 1,end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE,end: MIC_SIZE - 20);

  AnimatedMic({Key key,Animation<double> animation}):super(key:key,listenable:animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(opacity: _opacityTween.evaluate(animation),
    child: Container(
      height: _sizeTween.evaluate(animation),
      width: _sizeTween.evaluate(animation),
      decoration: BoxDecoration(
        color: Colors.cyanAccent,
        borderRadius: BorderRadius.circular(MIC_SIZE/2)
      ),child: Icon(Icons.mic,color: Colors.white,size: 30)
    ),
    );
  }
  
}

