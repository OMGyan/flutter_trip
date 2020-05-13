import 'package:flutter/material.dart';
enum SearchBarType{home,normal,homeLight}

class SearchBar extends StatefulWidget{

  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftBtnClick;
  final void Function() rightBtnClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChange;

  const SearchBar({
    Key key,
    this.enabled = true,
    this.hideLeft,
    this.searchBarType = SearchBarType.normal,
    this.hint,
    this.defaultText,
    this.leftBtnClick,
    this.rightBtnClick,
    this.speakClick,
    this.inputBoxClick,
    this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchBarState();
  }

}

class _SearchBarState extends State<SearchBar>{
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if(widget.defaultText!=null){
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal?
    _genNormalSearch():_genHomeSearch();
  }

  _genNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(Container(
            padding: EdgeInsets.fromLTRB(6,5,10,5),
            child: widget?.hideLeft??false?null:Icon(Icons.arrow_back,
            color: Colors.grey,size: 26,),
          ),widget.leftBtnClick),
          Expanded(child: _inputBox()),
          _wrapTap(Container(
            padding: EdgeInsets.fromLTRB(10,5,10,5),
            child: Text("搜索",style: TextStyle(color: Colors.blue,fontSize: 17))
          ),widget.rightBtnClick)
        ],
      ),
    );
  }

  _inputBox(){
    Color inputBoxColor;
    inputBoxColor = widget.searchBarType == SearchBarType.home?
        Colors.white:Color(int.parse('0xffededed'));
    return Container(height:30,
        padding: EdgeInsets.fromLTRB(10,0,10,0),
        decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
            widget.searchBarType == SearchBarType.normal?5:15)
        ), child: Row(
      children: <Widget>[
        Icon(Icons.search,size: 20,color: widget.searchBarType == SearchBarType.normal?
          Color(0xffa9a9a9):Colors.blue),
        Expanded(child: widget.searchBarType==SearchBarType.normal?
        TextField(controller: _controller,onChanged: _onChanged,
        style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w300,
          textBaseline: TextBaseline.alphabetic,
        ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(5,0,5,0),
            border: InputBorder.none,
            hintText: widget.hint??'',
            hintStyle: TextStyle(fontSize: 15,textBaseline: TextBaseline.alphabetic,)
          )
        ): _wrapTap(Container(
              child: Text(widget.defaultText,style: TextStyle(fontSize: 13,color: Colors.grey))
            ),widget.inputBoxClick)
        ),
        !showClear?_wrapTap(Icon(Icons.mic,
        size: 22,color: widget.searchBarType == SearchBarType.normal?
          Colors.blue:Colors.grey,),widget.speakClick):
            _wrapTap(Icon(Icons.clear,size: 22,color: Colors.grey),(){
              setState(() {
                _controller.clear();
              });
              _onChanged('');
            })]
    ));
  }
  _genHomeSearch(){
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(Container(
            padding: EdgeInsets.fromLTRB(6,5,5,5),
            child: Row(children: <Widget>[
              Text("上海",style: TextStyle(fontSize: 14,color: _homeFontColor())),
              Icon(Icons.expand_more,color: _homeFontColor(),size: 22)
            ],)
          ),widget.leftBtnClick),
          Expanded(child: _inputBox()),
          _wrapTap(Container(
              padding: EdgeInsets.fromLTRB(10,5,10,5),
              child: Icon(Icons.comment,color: _homeFontColor(),size: 26)
          ),widget.rightBtnClick)
        ],
      ),
    );
  }

  _homeFontColor(){
    return widget.searchBarType == SearchBarType.homeLight?
        Colors.black54:Colors.white;
  }

  _onChanged(String text){
    if(text.length>0){
      setState(() {
        showClear = true;
      });
    }else{
      setState(() {
        showClear = false;
      });
    }
    if(widget.onChange != null){
      widget.onChange(text);
    }
  }
  _wrapTap(Widget child,void Function() callback){
    return GestureDetector(
      onTap: (){
        if(callback!=null) callback();
      },child: child,);
  }
}