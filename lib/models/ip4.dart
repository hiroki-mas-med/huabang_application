
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IP4 with ChangeNotifier{
  List<String> value;
  IP4(List<String> ip4){
    this.value = ip4;
  }

  setIP4(List<String> ip4){
    this.value = ip4;
    notifyListeners();
  }
}

Future<List<String>> readip4()async{
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.getStringList("ip4");
  if (value == null){
    value = [null, null, null, null];
  }
  return value;
}

// 個個の入力欄がOKか判断
String validateIP(String ip){
  String errMessage = "Enter valid IP";
  try{
    var ipn = int.parse(ip);
    if (0 <= ipn && ipn <= 255){
      return null;
    }else{
      return errMessage;
    }
  }catch(e){
    return errMessage;
  }
}

// IP4全体が保存して大丈夫な状態かを確認
bool checkIP4(List<String> ip4){
  for (int idx = 0; idx < ip4.length; idx++) {
    if (validateIP(ip4[idx]) != null){
      return false;
    }
  }
  return true;
}
