
import 'package:bookadministration/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int myIndex = 0;
  List data = [
    Color.fromRGBO(177, 2, 15, 0.8),
    Color.fromRGBO(11, 35, 63, 0.8),
    Color.fromRGBO(75, 107, 141, 0.8),
  ];
    // 总数
  int _count = 20;
  var dio = new Dio();
  var _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
       ///用_futureBuilderFuture来保存_gerData()的结果，以避免不必要的ui重绘
   _futureBuilderFuture = _getData();
    // _getData();
  }

  Future _getData() async {
    try{
      Response response ;
      response = await dio.get('http://v.juhe.cn/toutiao/index', queryParameters: {
        'type':'guonei',
        'key':'8390ce89c6f7ae556fbaa1434673015e'
      });
      if(response.statusCode == 200){
        return response.data['result']['data'];
      }else{
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
      
    }catch(e){
      return print('ERROR:======>${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: ScreenAdapter.setWidth(400),
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper:BottomClipper(),
                  child: Container(
                    height: ScreenAdapter.setHeight(350),
                    color: data[myIndex],
                  ),
                  // child: swiperStylePage()
                ),
                Positioned(
                  width: ScreenAdapter.setWidth(750),
                  height: ScreenAdapter.setHeight(300),
                  top: ScreenAdapter.setHeight(170),
                  child: Container(
                    child: swiperPage(),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:ScreenAdapter.setHeight(400)),
            child:FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return EasyRefresh.custom(
                            footer: PhoenixFooter(),
                            onLoad: () async {
                              await Future.delayed(Duration(seconds: 2), () {
                                Fluttertoast.showToast(msg: '已经到底了');
                              });
                            },
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return InkWell(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/webview', arguments: snapshot.data[index]['url']);
                                      },
                                      child: widgetItem(snapshot.data[index]),
                                    );
                                  },
                                  childCount: snapshot.data.length,
                                ),
                              ),
                            ],
                          );
                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
             
          )
          
        ],
      )
    );
  }

// 内容
Widget widgetItem(val){
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: ScreenAdapter.setHeight(0.5),
          color: Colors.black12
        )
      )
    ),
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.all(ScreenAdapter.setWidth(15)),
    margin: EdgeInsets.all(ScreenAdapter.setWidth(15)),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(val['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ScreenAdapter.size(35)),),
            ),
            Expanded(
              flex: 1,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage, 
                image: val['thumbnail_pic_s']
              ),
            )
          ],
        ),
        SizedBox(height: ScreenAdapter.setHeight(10),),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(val['author_name'], style: TextStyle(color: Colors.black26, fontSize: ScreenAdapter.size(25)),),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(val['date'], style: TextStyle(color: Colors.black26, fontSize: ScreenAdapter.size(25)),),
              )
            )
          ],
        ),
      ],
    ),
  );
}

// 轮播图
Widget swiperPage(){
  List data = [
    'https://bossaudioandcomic-1252317822.image.myqcloud.com/activity/document/7a252584150962528ae3c5ebec79d879.jpeg',
    'https://bossaudioandcomic-1252317822.image.myqcloud.com/activity/document/47f652e7253105136d7ad7625bba05e2.jpg',
    'https://bossaudioandcomic-1252317822.image.myqcloud.com/activity/document/ebeb00c56505c97b7c50ff8f987269c0.jpg'
  ];
  return Swiper(
        itemBuilder: (BuildContext context,int index){
          return Container(
            padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
            child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                         image: data[index], fit: BoxFit.cover,),
          );
        },
        itemCount: data.length,
        autoplay: true,
        // pagination:  SwiperPagination(),
        onIndexChanged:(index){
          setState(() {
            myIndex = index;
          });
        }
      );
}

}

// 贝塞尔曲线
class BottomClipper extends CustomClipper<Path>{
  @override
    Path getClip(Size size) {
      // TODO: implement getClip
      var path = Path();
      path.lineTo(0, 0);
      path.lineTo(0, size.height-30);
      var firstControlPoint =Offset(size.width/2,size.height);
      var firstEndPoint = Offset(size.width,size.height-30);

      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      path.lineTo(size.width, size.height-30);
      path.lineTo(size.width, 0);

      return path;

    }
    @override
      bool shouldReclip(CustomClipper<Path> oldClipper) {
        // TODO: implement shouldReclip
        return false;
      }

}