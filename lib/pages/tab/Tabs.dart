import 'package:bookadministration/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'Search.dart';
import 'User.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {

  List<Widget> _widgetList;
  int _currentIndex;
  FabCircularMenuController _controller = new FabCircularMenuController();

  @override
  void initState() {
    super.initState();
    _widgetList = [HomePage(), SearchPage(), UserPage()];
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    // 初始化
    ScreenAdapter.init(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('图书管理系统'),
      // ),
      body:FabCircularMenu(
        controller: _controller,
        ringColor:Colors.black45,
        ringWidth:ScreenAdapter.setWidth(80),
        ringDiameter:200.0,
        child: _widgetList[_currentIndex],
        options: <Widget>[
          IconButton(icon: Icon(IconData(0xe622, fontFamily: 'MyIcon'), color: Colors.white,), onPressed: () {
            final arguments = {
              'title':'还书'
            };
            Navigator.pushNamed(context, '/form', arguments: arguments).then((_){
              setState(() {
                _controller.isOpen = false;
              });
            });
          }),
          IconButton(icon: Icon(IconData(0xe624, fontFamily: 'MyIcon'), color: Colors.white,), onPressed: () {
            final arguments = {
              'title':'借书'
            };
            Navigator.pushNamed(context, '/form', arguments: arguments).then((_){
              setState(() {
                _controller.isOpen = false;
              });
            });
          }),
          IconButton(icon: Icon(IconData(0xe623, fontFamily: 'MyIcon'), color: Colors.white,), onPressed: () {
            final arguments = {
              'title':'添加图书'
            };
            Navigator.pushNamed(context, '/form', arguments: arguments).then((_){
              setState(() {
                _controller.isOpen = false;
              });
            });
          }),
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('查询')),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('用户'))
        ]
      ),
    );
  }
}