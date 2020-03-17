import 'package:bookadministration/provider/userBookProvider.dart';
import 'package:bookadministration/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ListPage extends StatefulWidget {
  final arguments;
  ListPage(this.arguments);
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  // int _count = 5;
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _sexcontroller = TextEditingController();
  TextEditingController _codecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bookData = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.arguments['title']}列表'),
        actions: <Widget>[
          widget.arguments['title'] == 'Vip' ? 
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              _formalertDialog(context, '添加会员', (){
                if(_namecontroller.text == '' && _sexcontroller.text == '' && _codecontroller.text == ''){
                  Fluttertoast.showToast(msg: '填写有误！');
                }
                final arguments = {
                  'name':_namecontroller.text,
                  'sex':_sexcontroller.text,
                  'code':_codecontroller.text
                };
                for(var i = 0; i<bookData.vipList.length; i++){
                  if(_codecontroller.text == bookData.vipList[i]['code'].toString()){
                    Fluttertoast.showToast(msg: '抱歉，该会员号已添加！');
                  }else{
                    bookData.setVip(arguments);
                    Navigator.pop(context);
                  }
                }
              });
            },
          )
          :
          Container()
        ],
      ),
      body:  EasyRefresh.custom(
        header: PhoenixHeader(),
        footer: PhoenixFooter(),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            Fluttertoast.showToast(msg: '已是最新数据了！');
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            Fluttertoast.showToast(msg: '没有更多数据了！');
          });
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if(widget.arguments['title'] == 'Vip'){
                  return vipList(bookData.vipList[index]);
                }else{
                  return InkWell(
                    child: listItem(bookData.myBooks[index]),
                    onTap: (){
                      _alertDialog(context, '确认还书', (){
                        bookData.removemyBooks(bookData.myBooks[index]['bookname']);
                        Navigator.pop(context);
                      });
                    },
                  );
                }
              },
              childCount:widget.arguments['title'] == 'Vip' ? 
              bookData.vipList.length
              :
              bookData.myBooks.length
            ),
          ),
        ],
      ),
    );
  }

//   我借的图书的列表
  Widget listItem(val){
    return ListTile(
                leading: Container(
                  width: ScreenAdapter.setWidth(120),
                  child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage, 
                  image: val['image'],
                  fit: BoxFit.cover,
                ),
                ),
                title: Text(
                          '${val['bookname']}', 
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenAdapter.size(30)),),
                subtitle: Text(val['descrip'], maxLines: 3, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: ScreenAdapter.size(26))),
              );
  }

  //   我借的图书的列表
  Widget vipList(val){
    return ListTile(
              leading: Icon(IconData(0xe625, fontFamily: 'MyIcon'), color: Colors.orange),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                        '${val['name']}', 
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenAdapter.size(30)),),
                  Text('${val['sex']}',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenAdapter.size(30)),)
                ],
              ),
              subtitle: Text('${val['code']}', maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: ScreenAdapter.size(26))),
            );
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

   _formalertDialog(context, msg, fn) {
    showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('添加会员',style: TextStyle(fontSize: ScreenAdapter.size(30))),
            content: Container(
              height: ScreenAdapter.setHeight(400),
              child: Column(
              children: <Widget>[
                TextField(
                  controller: _namecontroller,
                  decoration: InputDecoration(
                    hintText: '请输入会员名',
                    hintStyle: TextStyle(fontSize: ScreenAdapter.size(30))
                  ),
                ),
                TextField(
                  controller: _sexcontroller,
                  decoration: InputDecoration(
                    hintText: '请输入性别',
                    hintStyle: TextStyle(fontSize: ScreenAdapter.size(30))
                  ),
                ),
                TextField(
                  controller: _codecontroller,
                  decoration: InputDecoration(
                    hintText: '请输入会员号',
                    hintStyle: TextStyle(fontSize: ScreenAdapter.size(30))
                  ),
                ),
              ],
            ),
            ),
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