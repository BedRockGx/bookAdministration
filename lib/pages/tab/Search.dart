
import 'package:bookadministration/provider/userBookProvider.dart';
import 'package:bookadministration/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  bool isSearch = false;
  TextEditingController _keywords = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          elevation: 0,
          title: Container(
            height: ScreenAdapter.setHeight(70),
            decoration: BoxDecoration(
                color: Color.fromRGBO(200, 200, 200, 0.3),
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: ScreenAdapter.setWidth(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 上下居中
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenAdapter.setWidth(10)),
                  child: Icon(
                    Icons.search,
                    size: ScreenAdapter.size(40),
                    color: Color.fromRGBO(200, 200, 200, 0.8),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _keywords,
                      autofocus: false,
                      // 去掉boder的默认边框
                      style: TextStyle(fontSize: ScreenAdapter.size(30)),
                      decoration: InputDecoration(
                          // icon: Icon(Icons.search),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: '请输入关键字',
                          hintStyle: TextStyle(fontSize: ScreenAdapter.size(30)),
                          contentPadding: EdgeInsets.fromLTRB(
                              0, 0, 0, ScreenAdapter.setHeight(20))),
                      onChanged: (value) {
                        if (value != '') {
                          setState(() {
                            isSearch = true;
                            this._keywords.text = value;
                          });
                        } else {
                          setState(() {
                            isSearch = false;
                          });
                        }
                        // 如果绑定了控制器，可利用此方法避免文本框的Bug
                        _keywords.selection = TextSelection.fromPosition(
                            TextPosition(offset: _keywords.text.length));
                      },
                    ))
              ],
            ),
          ),
        ),
      body: _isShowRecommend(),
    );
  }


  // 是否展示搜索推荐
  Widget _isShowRecommend() {
    var bookData = Provider.of<BookProvider>(context);
    
    // 如果没有数据，就返回推荐数组，如果有数据就返回数组当中查找到的
    final suggestionList = _keywords.text.isEmpty
        ? bookData.recentBooks
        : bookData.borrowBooks
            .where((input) => input['bookname'].startsWith(_keywords.text))
            .toList();
    return ListView.builder(
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child:
              ListTile(
                leading: Container(
                  width: ScreenAdapter.setWidth(120),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage, 
                    image: suggestionList[index]['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                title: RichText(
                    text: TextSpan(
                        text: suggestionList[index]['bookname']
                            .substring(0, _keywords.text.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenAdapter.size(30)),
                        children: [
                      TextSpan(
                          text: suggestionList[index]['bookname']
                              .substring(_keywords.text.length),
                          style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(30)))
                    ])),
                subtitle: Text(suggestionList[index]['descrip'], maxLines: 3, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: ScreenAdapter.size(26))),
              ),
              onTap: (){
                _alertDialog(context, '确定要借这本书吗', (){
                  final arguments = {
                    'bookname':suggestionList[index]['bookname'],
                    'image':suggestionList[index]['image'],
                    'descrip':suggestionList[index]['descrip']
                  };
                  bookData.setMyBooks(arguments);
                  
                  Navigator.pop(context);
                });
              },
            );
          });
  }

  _alertDialog(context, msg, fn) {
    showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示',style: TextStyle(fontSize: ScreenAdapter.size(30))),
            content: Text('$msg',style: TextStyle(fontSize: ScreenAdapter.size(30))),
            actions: <Widget>[
              FlatButton(
                child: Text('取消', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                onPressed: () {
                  print('点击了取消');
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text('确定',style: TextStyle(fontSize: ScreenAdapter.size(30))),
                onPressed: fn
              )
            ],
          );
        });
  }
}