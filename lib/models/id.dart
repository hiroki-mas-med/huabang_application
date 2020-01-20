import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ID with ChangeNotifier{
  String value;  
  
  void setID(String id){
    this.value = id;
    notifyListeners();
  }
}

String validateID(String id){
  Pattern pattern = r'(^[0-9]+$)';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(id)){
    return "Enter valid ID";
  }else{
    return null;
  }
}

