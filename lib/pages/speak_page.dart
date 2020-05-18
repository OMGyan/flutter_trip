import 'package:flutter/material.dart';

///语音识别页面
class SpeakPage extends StatefulWidget{
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage>{
  String speakTips = '长按说话';
  Animation<double> animation;
  AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text('我的')
      )
    );
  }
  _speakStart(){

  }
  _speakStop(){

  }
  _speakCancel(){

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
          )
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

