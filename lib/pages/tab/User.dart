import 'package:bookadministration/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

/// 个人中心页面
class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            EasyRefresh.custom(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    // 顶部栏
                    new Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height:220.0,
                          color: Colors.white,
                        ),
                        ClipPath(
                          clipper: new TopBarClipper(
                              MediaQuery.of(context).size.width, 200.0),
                          child: new SizedBox(
                            width: double.infinity,
                            height: 200.0,
                            child: new Container(
                              width: double.infinity,
                              height: 240.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        // 名字
                        Container(
                          margin: new EdgeInsets.only(top: 50.0),
                          child: new Center(
                            child: new Text(
                              '管理员',
                              style: new TextStyle(
                                  fontSize: ScreenAdapter.size(40), color: Colors.white),
                            ),
                          ),
                        ),
                        // 图标
                        Container(
                          margin: new EdgeInsets.only(top: 100.0),
                          child: new Center(
                              child: new Container(
                            width: 100.0,
                            height: 100.0,
                            child: new PreferredSize(
                              child: new Container(
                                child: new ClipOval(
                                  child: new Container(
                                    color: Colors.white,
                                    child: new Image.asset(
                                        'assets/images/user.jpg'),
                                  ),
                                ),
                              ),
                              preferredSize: new Size(80.0, 80.0),
                            ),
                          )),
                        ),
                      ],
                    ),
                    // 内容
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                          // color: Colors.blue,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: ListTile(
                                    leading: Icon(IconData(0xe624, fontFamily: 'myIcon')),
                                    title: Text('我借的书', style: TextStyle( fontSize: ScreenAdapter.size(30)),),
                                  ),
                                  onTap: (){
                                    final arguments = {
                                      'title':'借书'
                                    };
                                    Navigator.pushNamed(context, '/ListPage', arguments: arguments);
                                  },
                                ),
                                Divider(),
                                InkWell(
                                  child: ListTile(
                                    leading: Icon(IconData(0xe625, fontFamily: 'MyIcon'), color: Colors.orange,),
                                    title: Text('查询会员', style: TextStyle(fontSize: ScreenAdapter.size(30))),
                                  ),
                                  onTap: (){
                                    final arguments = {
                                      'title':'Vip'
                                    };
                                    Navigator.pushNamed(context, '/ListPage', arguments: arguments);
                                  },
                                )
                              ],
                            ),
                          )),
                    ),
                   
                  ]),
                ),
              ],
            ),
          ],
        ));
  }
}

// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopBarClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height / 2);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
