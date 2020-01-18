import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


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
Map<String, List<String>> calc_dates(List<String> fpaths){
  Map<String, List<String>> result = {};
  for (int idx = 0; idx < fpaths.length; idx++){
    String col = converdate2string(DateTime.now());
    if (result[col] == null){
      result[col] = [fpaths[idx]];
    }else{
      result[col].add(fpaths[idx]);
    }
  }
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


  void GalleryUploadDialog(BuildContext context, List<String> sfpaths){
    var sentence = sfpaths.length.toInt().toString() + "個のファイルが選択されています\n" +
      "ファイル名は下記のとおりです、アップロードしてよろしいでしょうか？\n\n";
    sfpaths.forEach((sfpath){
      sentence += sfpath.split("/").last + "\n";
    });

    showDialog(
      context: context,
      builder: (_) =>
        AlertDialog(
          title: Text("アップロード"),
          content: SingleChildScrollView(
            child: Text(sentence),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("アップロード"),
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

  void GalleryDeleteDialog(BuildContext context, List<String> sfpaths){
    var sentence = sfpaths.length.toInt().toString() + "個のファイルが選択されています\n" +
      "ファイル名は下記のとおりです、削除してよろしいでしょうか？\n\n";
    sfpaths.forEach((sfpath){
      sentence += sfpath.split("/").last + "\n";
    });
    showDialog(
      context: context,
      builder: (_) =>
        AlertDialog(
          title: Text("削除"),
          content: Text(sentence),
          actions: <Widget>[
            FlatButton(
              child: Text("削除"),
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
