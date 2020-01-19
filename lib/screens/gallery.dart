import 'dart:io';
import 'package:flutter/material.dart';
import 'package:huabang_application/models/id.dart';
import 'package:huabang_application/models/ip4.dart';
import 'package:huabang_application/other.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar.dart';


class GalleryPage extends StatefulWidget{
  GalleryPage({Key key}) : super(key: key);
  @override
  _GalleryPageState createState() => new _GalleryPageState();
}


class _GalleryPageState extends State<GalleryPage> {
  // 選んだFileパス一覧
  List<File> selectedFiles = [];
  // 日付とファイルのセット
  Map<String, List<File>> file_dates = {};
  // ID
  String id;
  // IPのリスト
  List<String> ip4;
  // isUploading（Circularを表示するためのマーク）
  bool isUploading = false;
  // これがOKなら、アップロードマークを表示しない
  bool isOk = false;
  String dirpath;
  String url;
  int n_column = 3;



  // ここからボタンを押した場合の表示
  void onPressUploadButton(BuildContext context){
    var sentence = selectedFiles.length.toInt().toString() + "個のファイルが選択されています\n" +
      "ファイル名は下記のとおりです、アップロードしてよろしいでしょうか？\n\n";
    selectedFiles.forEach((selectedFile){
      sentence += selectedFile.path.split("/").last + "\n";
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
                Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
                print("Upload");
                selectedFiles.forEach((sfile) async {
                  var sfpath  =sfile.path;
                  var sfilename = sfpath.split("/").last;
                  print(sfpath);
                  var uploadResult = await uploadFile(url, sfilename, sfpath);
                  if (!uploadResult){
                    String err = "アップロードに失敗しました";
                    stopDialog(err, context);
                  }
                });
                print("Upload finish");
              },
            ),
            FlatButton(
              child: Text("キャンセル"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );

  }

  void onPressDeleteButton(BuildContext context){
    var sentence = selectedFiles.length.toInt().toString() + "個のファイルが選択されています\n" +
      "ファイル名は下記のとおりです、削除してよろしいでしょうか？\n\n";
    selectedFiles.forEach((selectedFile){
      sentence += selectedFile.path.split("/").last + "\n";
    });
    showDialog(
      context: context,
      builder: (_) =>
        AlertDialog(
          title: Text("削除"),
          content: SingleChildScrollView(
            child: Text(sentence),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("削除"),
              onPressed: (){
                print("delete");
                Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
                selectedFiles.forEach((selectedFile){
                  selectedFile.deleteSync(recursive: true);
                  print(selectedFile.path);
                });
              },
            ),
            FlatButton(
              child: Text("キャンセル"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  void onPressHomeButton(BuildContext context){
    print("Home");
    Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
  }

  void onPressConfigButton(BuildContext context){
    print("Config");
    Navigator.of(context).pushNamedAndRemoveUntil('/config', (_) => false);        
  }

  void onPressImageButton(BuildContext context, File file){
    Navigator.of(context).pushNamed('/image', arguments: file);
  }

  void onLongPressImageButton(File file){
    if (!selectedFiles.contains(file)){
      selectedFiles.add(file);
      print(["add", file.path]);
      setState(() {
        
      });
    }else{
      selectedFiles.remove(file);
      print(["remove", file.path]);
      setState(() {
      });
    }
  }
  // ここまで
  
  // 選択した場合の色について
  Color selectedColor(File file){
    if(selectedFiles.contains(file)){
      return Colors.blue;
    }else{
      return Theme.of(context).canvasColor;
    }
  }

  // ダイアログについて
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
                Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
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



  // 始まるときの関数
  Future<void> initFunction()async{
    // ID, IPアドレス、IDのセーブパスを読み込み
    id = Provider.of<ID>(context, listen: false).value;
    ip4 = Provider.of<IP4>(context, listen: false).value;
    String cpath = await camerapath();
    dirpath = '${cpath}/${id}';

    // IDのセーブパスに画像があるなら、日付：ファイルパスのリストを作成、そうでなければ空のMapを
    try{
      List<FileSystemEntity> contents = Directory(dirpath).listSync();
      if (contents != null){
        setState(() {
          file_dates = calc_dates(contents);
        });
      }else{
        file_dates = {};
      }
    }catch(e){
      print(e);
      file_dates = {};
    }

    print(file_dates);

    // IPアドレスの形式をチェックして問題なければ、
    if(checkIP4(ip4)){
       // アップロード中に変更
       // test用のURLにアクセスし、結果がでれば
       // アップロード中を終了する。
       setState(() {
         isUploading = true;
       });       
       var url_tmp = convertip2url(ip4);
       var res = await testWiFi(url_tmp);
       setState(() {
         isUploading = false;
       });
       print(["WiFi check", res]);

       // testURLをチェックがOKなら
       // OKに変更し、アップロードURLを作成
       // もしNGなら、チェックダイアログを表示
       if (res){
         setState(() {
           isOk = true;
           url = url_tmp + "/image";
         });
       }else{
          String err = "転送先のURLを確認しましたが、接続できません";
          // 何かしらのエラーダイアログ、Homeボタンか、Configボタン
          checkDialog(err, context);
          setState(() {
           isOk = false;
          });
       }
    }else{
      String err = "転送先のURLを確認しましたが、接続できません";
      // 何かしらのエラーダイアログ、Homeボタンか、Configボタン
      checkDialog(err, context);
      setState(() {
        isOk = false;
      });

    }
  }



  @override
  void initState() {
    // String dir = "images/";
    initFunction();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // file_datesの日付のうち、新しいものから順に取得
    List<String> dates = file_dates.keys.toList()..sort();
    dates = dates.reversed.toList();
    // 画面横幅から、1/3の幅で、高さは4:3を想定
    double grid_width = MediaQuery.of(context).size.width;
    double solo_width = grid_width / n_column;
    double solo_height = solo_width * 3/4;

    // AppBarに表示するためのIcon
    Widget icon_home = IconButton(
      icon: Icon(Icons.home),
      color: isUploading ? Colors.grey : Theme.of(context).textTheme.button.color,
      onPressed: (){
        onPressHomeButton(context);
      },
    );

    Widget icon_setting= IconButton(
      icon: Icon(Icons.settings),
      color: isUploading ? Colors.grey : Theme.of(context).textTheme.button.color,
      onPressed: (){
        onPressConfigButton(context);
      },
    );


    Widget icon_delete = selectedFiles.length > 0 ?
      IconButton(
        icon: Icon(Icons.delete),
        color: isUploading ? Colors.grey : Theme.of(context).textTheme.button.color,
        onPressed: (){
          onPressDeleteButton(context);
        },
      ) 
      : Container();

    Widget icon_upload(){
      if(isOk && selectedFiles.length > 0){
        return IconButton(
          icon: Icon(Icons.file_upload),
          color: isUploading ? Colors.grey : Theme.of(context).textTheme.button.color,
          onPressed: (){
            onPressUploadButton(context);
          },
        );
      }else{
        return Container();
      }
    }

    final List<Widget> icons = [icon_upload(), icon_delete, icon_setting, icon_home];


    Widget upLoadingContent(){
      if (isUploading){
        return Container(
          alignment:Alignment.center,
          child: CircularProgressIndicator()
        );
      }else{
        return Container();
      }
    }




    List<Widget> contents(){
      // 日付が一日もなければ空のContainerを
      if (dates == null){
        return [Container()];
      }
      // そうでなければ
      else{
        return dates.map((date){
          // 日付ごとに、ファイル名を取得
          var files = file_dates[date];
          var lastint = files.length~/n_column;
          var restint = files.length - n_column * lastint;
          List<List<int>> idxlist = [];
          if(restint == 0){
            for(var i = 0; i < lastint; i++){
              idxlist.add(List<int>.generate(n_column, (int index){
                return n_column * i + index;
              }));
            }
          }else{
            for(var i = 0; i < lastint; i++){
              idxlist.add(List<int>.generate(n_column, (int index){
                return n_column * i + index;
              }));
            }
            idxlist.add(List<int>.generate(n_column, (int index){
              if(index < restint){
                return n_column * lastint + index;
              }else{
                return -1;
              }
            }));
          }
                  
          //　単独の高さから、画像を収録する箱の高さを計算　（ファイル数/3の切り上げ）
          double grid_height = (solo_height * (files.length/3).ceil()).toDouble();
          return Padding(
            padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: Column(
              children: <Widget>[
                // 日付表示部分：少しだけ左に寄せてある
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(date,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Roboto"
                      ),
                    ),
                  )
                ),
                
                // 画像表示部分
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    // ContainerのSizeを表示するのは、Columnでバグを出さないため
                    height: grid_height,
                    width: grid_width,
                    child: Column(
                      children: idxlist.map((idxs){
                        // idxs（つまり列のindex）をまとめた配列に対して
                        return Expanded(
                          flex: 1,
                          child: Container(
                            // ContainerのSizeを明示するのは、Rowでバグを出さないため
                            height: solo_height,
                            width: grid_width,
                            child: Row(
                              // -1の列があった場合にでも、列の配列がくずれないようにする
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: (idxs).map((idx){
                                if(idx != -1){                             
                                  return Expanded(
                                    child: Padding(                                    
                                      padding: EdgeInsets.all(1.0),                                      
                                      child: Container(             
                                        color: selectedColor(files[idx]),
                                        child: GestureDetector(
                                          onTap: (){
                                            onPressImageButton(context, files[idx]);
                                          },
                                          onLongPress: (){
                                            onLongPressImageButton(files[idx]);
                                          },
                                          child: RawMaterialButton(
                                            child: Image.file(files[idx]),
                                            onPressed: null,
                                            padding: EdgeInsets.all(5.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }else{
                                  return Expanded(
                                    child: Padding(                                    
                                      padding: EdgeInsets.all(1.0),
                                      child: Container(            
                                      ),
                                    ),
                                  );
                                }         
                              }).toList(),
                            )
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ),
              ],
            ),
          );
        }).toList();
      }
    }

    return Scaffold(
      appBar: CustomAppBar(height: 50, contents: icons),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: contents()
            ),
          ),
          upLoadingContent()
        ],
      )
    );
  }
}

