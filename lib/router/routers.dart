import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/tab/Tabs.dart';
import 'package:bookadministration/template/webViewPage.dart';
import 'package:bookadministration/template/handle.dart';
import 'package:bookadministration/template/formPage.dart';
import 'package:bookadministration/template/listPage.dart';

final routers = {
  '/':(context) => TabsPage(),
  '/webview':(context, {arguments}) => WebPage(arguments),
  '/handle':(context, {arguments}) => HandlePage(),
  '/form':(context, {arguments}) => FormPage(arguments),
  '/ListPage':(context, {arguments}) => ListPage(arguments),
};

final onGenerateRoute = (RouteSettings settings){
  final String router_url = settings.name;
  final Function router_fn = routers[router_url];

  if(router_fn != null && settings.arguments != null){
      final router = MaterialPageRoute(
        builder: (context) => router_fn(context, arguments:settings.arguments)
      );
      return router;
  }else{
      final router = MaterialPageRoute(
        builder: (context) => router_fn(context)
      );
      return router;
  }

};