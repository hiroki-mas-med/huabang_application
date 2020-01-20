import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dark with ChangeNotifier{
  bool value;
  Dark(bool dark){
    this.value = dark;
  }
  
  void setDark(bool dark){
    this.value = dark;
    notifyListeners();
  }  
}

Future<bool> readDark()async{
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.getBool("dark");
  if (value == null){
    value = false;
  }
  return value;
}
