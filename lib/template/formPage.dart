import 'package:bookadministration/provider/userBookProvider.dart';
import 'package:bookadministration/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {
  final arguments;
  FormPage(this.arguments);
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  TextEditingController code1 = TextEditingController();
  TextEditingController code2 = TextEditingController();

  TextEditingController bookcode = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final bookProvide = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments['title']),
      ),
      body: Container(
        margin: EdgeInsets.all(ScreenAdapter.setWidth(30)),
        child: ListView(
          children: <Widget>[
            widget.arguments['title'] != '添加图书' ? 
            Column(
              children: <Widget>[
                textWidget(code1, '学号'),
                textWidget(code2, '图书名称'),
              ],
            )
            :
            Column(
              children: <Widget>[
                textWidget(bookcode, '图书编号'),
                textWidget(code1, '图书名称'),
                textWidget(code2, '图书描述'),
              ],
            ),
            SizedBox(height: ScreenAdapter.setHeight(30),),
            RaisedButton(
              child: Text('确认${widget.arguments['title']}'),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              onPressed: (){
                if(code1.text != '' && code2.text != ''){
                  if(widget.arguments['title'] == '添加图书'){
                    final arguments = {
                      'bookname':code1.text,
                      'image':'https://bkimg.cdn.bcebos.com/pic/8718367adab44aed95fdcd3dbd1c8701a08bfbbc?x-bce-process=image/resize,m_lfit,w_268,limit_1/format,f_jpg',
                      'descrip':code2.text
                    };
                    bookProvide.setBorrowBooks(arguments);
                    Fluttertoast.showToast(msg: '添加成功');
                  }else if(widget.arguments['title'] == '借书'){
                    for(var i  = 0; i<bookProvide.borrowBooks.length; i++){
                      if(code2.text == bookProvide.borrowBooks[i]['bookname']){
                        final arguments = {
                          'bookname':bookProvide.borrowBooks[i]['bookname'],
                          'image':bookProvide.borrowBooks[i]['image'],
                          'descrip':bookProvide.borrowBooks[i]['descrip']
                        };
                        bookProvide.setMyBooks(arguments);
                        Fluttertoast.showToast(msg: '借书成功');
                      }
                    }
                  }else{
                    bookProvide.removemyBooks(code2.text);
                  }
                }else{
                  Fluttertoast.showToast(msg: '填写有误！');
                }

                
                
              },
            )
          ],
        ),
      )
    );
  }

  Widget textWidget(controller, title){
    final _height = ScreenAdapter.setWidth(180);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: Colors.black26
          )
        )
      ),
      child: Row(
              children: <Widget>[
                Container(
                  width: _height,
                  child: Text('$title：', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入$title',
                      hintStyle: TextStyle(fontSize: ScreenAdapter.size(30))
                    ),
                  ),
                )
              ],
            ),
    );
  }
}