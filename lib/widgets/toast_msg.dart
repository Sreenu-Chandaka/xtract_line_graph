import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ToastMsg{
  static msg(String msg){
    return  Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        webPosition: "center",
        webBgColor: "#b2dfdb",
        timeInSecForIosWeb: 2,
      );
  }
  
}