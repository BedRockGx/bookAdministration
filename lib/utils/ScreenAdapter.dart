import 'package:flutter_screenutil/flutter_screenutil.dart';

//  封装屏幕适配类

class ScreenAdapter {
  // 初始化
  static init(context){
    //设置字体大小根据系统的“字体大小”辅助选项来进行缩放,默认为false
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
  }
  // 设置高度
  static setWidth(double n){
    return ScreenUtil().setWidth(n);
  }

  // 设置宽度
  static setHeight(double n){
    return ScreenUtil().setHeight(n);
  }

  // 获取屏幕像素宽度
  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  // 获取屏幕像素高度
  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }

  // 获取屏幕宽度
  static getPxWidth(){
    return ScreenUtil.screenWidth;
  }

  // 获取屏幕高度
  static getPxHeight(){
    return ScreenUtil.screenHeight;
  }

  // 适配字体高度
  static size(double size){
    return ScreenUtil().setSp(size);
  }
}