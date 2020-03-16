import 'package:fluttertoast/fluttertoast.dart';

import 'asset.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier{
    List<Map> _borrowBooks = List.from(searchList);
    List<Map> _recentBooks = List.from(recentSuggest);

    List<Map> _myBooks = [];
    List<Map> _vipList = [
      {
        'name':'管理员',
        'sex':'女',
        'code':201790233005
      }
    ];
    

    List<Map> get borrowBooks => _borrowBooks;
    List<Map> get recentBooks => _recentBooks;
    List<Map> get myBooks => _myBooks;                // 我借的书
    List<Map> get vipList => _vipList;

    setBorrowBooks(val){
      this._borrowBooks.add(val);
      notifyListeners();
    }

    removemyBooks(val){
      for(var i = 0; i<this._myBooks.length; i++){
        if(val == this._myBooks[i]['bookname']){
          this._myBooks.removeAt(i);
          Fluttertoast.showToast(msg: '还书成功');
          break;
        }else{
          if(i == this._myBooks.length-1){
            Fluttertoast.showToast(msg: '您好像没有借这本书呦！');
          }
        }
      }
      notifyListeners();
    }

    setMyBooks(val){
      if(this._myBooks.isEmpty){
        this._myBooks.add(val);
        Fluttertoast.showToast(msg: '借书成功');
        return;
      }
      print(val['bookname']);

      for(var i = 0; i<this._myBooks.length; i++){
        print(i);
        print(this._myBooks[i]['bookname']);
        print(val['bookname'] == this._myBooks[i]['bookname']);
        if(val['bookname'] == this._myBooks[i]['bookname']){
          Fluttertoast.showToast(msg: '您已经借过此书了');
          break;
        }else{
          if(i == this._myBooks.length-1){
            this._myBooks.add(val);
            Fluttertoast.showToast(msg: '借书成功');
            break;
          }
          
        }
      }
      notifyListeners();
    }

    setVip(val){
      this._vipList.add(val);
      notifyListeners();
    }
}