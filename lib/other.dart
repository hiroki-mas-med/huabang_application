import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


Future<String> camerapath()async{
  final Directory extDir = await getExternalStorageDirectory();
  // final Directory extDir = Directory("/storage/emulated/0/Pictures/huabang");
  String path = '${extDir.path}/Pictures';
  return path;
}

// IDと現在時間から、辞書を作成
List<String> makeFileName(String id, String lr){
  var now = DateTime.now();
  var y = DateFormat.y().format(now);
  var M = DateFormat.M().format(now);
  var d = DateFormat.d().format(now);
  var H = DateFormat.H().format(now);
  var m = DateFormat.m().format(now);
  var s = DateFormat.s().format(now);
  var mi = now.millisecond;
  String day = y.padLeft(4, '0') + M.padLeft(2, '0') + d.padLeft(2, '0');
  String filename = day + H.padLeft(2, '0') + m.padLeft(2, '0') + s.padLeft(2, '0') +mi.toString().padLeft(3, "0") +
      "_"  + id + "_" +  lr + ".png";
  return [day, filename];
}

// File名から日付ごとの辞書を作成、
Map<String, List<File>> calc_dates(List<FileSystemEntity> files){
  Map<String, List<File>> result = {};
  files.forEach((file){
    DateTime date = File(file.path).lastModifiedSync();
    print(date);
    String day = converdate2string(date);
    if (result[day] == null){
      result[day] = [file];
    }else{
      result[day].add(file);
    }
  });
  return result;
}

String converdate2string(DateTime date){
  var y = DateFormat.y().format(date);
  var M = DateFormat.M().format(date);
  var d = DateFormat.d().format(date);
  return y + "/" + M + "/" + d;
}


// Dialog関係
  void errorDialog(String content, BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) => 
        AlertDialog(
          title: Text("エラー"),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("ホーム画面に戻る"),
              onPressed: (){
                Navigator.of(context).pushNamed('/');
              },
            ),
            FlatButton(
              child: Text("自動転送を一時的に無効にし、続行"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  void confirmDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (_) =>
        AlertDialog(
          title: Text("確認"),
          content: Text("自動転送がオフになっています、よろしいですか？"),
          actions: <Widget>[
            FlatButton(
              child: Text("ホーム画面に戻る"),
              onPressed: (){
                Navigator.of(context).pushNamed('/');
              },
            ),
            FlatButton(
              child: Text("続行"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  // Gallery画面のDialog
  void checkDialog(String content, BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) => 
        AlertDialog(
          title: Text("エラー"),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("ホーム画面に戻る"),
              onPressed: (){
                Navigator.of(context).pushNamed('/');
              },
            ),
            FlatButton(
              child: Text("アップロードは行わない"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }


  void stopDialog(String content, BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) => 
        AlertDialog(
          title: Text("エラー"),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("ホーム画面に戻る"),
              onPressed: (){
                Navigator.of(context).pushNamed('/');
              },
            ),
          ],
        )
    );
  }


// WiFi関連
  String convertip2url(List<String> iplist){
    return "http://" + iplist[0] + "." + iplist[1] + "." + iplist[2] + "." + iplist[3] + ":5042";
  }

  Future<bool> testWiFi(String url)async{
    try{
      var res = await http.get(url).timeout(Duration(seconds: 3));
      if (res.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch (e){
      print(e);
      return false;
    }
  }

  Future<bool> uploadFile(String url, String file, String fpath)async{
    try{
      String base64Image = base64Encode(File(fpath).readAsBytesSync());
      var res = await http.post(url, body: {"image": base64Image, "name": file}).timeout(Duration(seconds: 3));
      if (res.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch (e){
      print(e);
      return false;
    }
  }
