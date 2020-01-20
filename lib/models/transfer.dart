import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transfer with ChangeNotifier{
  bool value;
  Transfer(bool transfer){
    this.value = transfer;
  }
  
  void setTransfer(bool transfer){
    this.value = transfer;
    notifyListeners();
  }  
}

Future<bool> readTransfer()async{
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.getBool("transfer");
  if (value == null){
    value = false;
  }
  return value;
}
