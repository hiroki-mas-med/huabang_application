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
  List<String> selectedFiles = [];
  Map<String, List<String>> file_dates = {};
  String id;
  List<String> ip4;
  bool isUploading = false;
  bool isOk = false;


  void onPressUploadButton(BuildContext context){
    print("Upload");
    GalleryUploadDialog(context, selectedFiles);
  }

  void onPressDeleteButton(BuildContext context){
    print("Delete");
    GalleryDeleteDialog(context, selectedFiles);
  }

  void onPressHomeButton(BuildContext context){
    print("Home");
    Navigator.of(context).pushNamed("/");
  }

  void onPressConfigButton(BuildContext context){
    print("Config");
    Navigator.of(context).pushNamed('/config');        
  }

  void onPressImageButton(BuildContext context, String fpath){
    Navigator.of(context).pushNamed('/image', arguments: fpath);
  }

  void onLongPressImageButton(String fpath){
    if (!selectedFiles.contains(fpath)){
      selectedFiles.add(fpath);
      print("Add");
      setState(() {
        
      });
    }else{
      selectedFiles.remove(fpath);
      print("Remove");
      setState(() {
        
      });
    }
  }

  Color selectedColor(fpath){
    if(selectedFiles.contains(fpath)){
      return Colors.blue;
    }else{
      return Theme.of(context).canvasColor;
    }
  }


  Future<void> initFunction()async{
    id = Provider.of<ID>(context, listen: false).value;
    ip4 = Provider.of<IP4>(context, listen: false).value;
    //List<FileSystemEntity> contents = Directory(dir).listSync();
    //List<String> fpaths = contents.map((content){return content.path;}).toList();
    List<String> fpaths = ["images/logo.png", "images/sample.jpeg"];
    setState(() {
      file_dates = calc_dates(fpaths);
    });
    if(checkIP4(ip4)){
       setState(() {
         isUploading = true;
       });
       var res = await testWiFi(convertip2url(ip4));
       setState(() {
         isUploading = false;
       });
       print(["WiFi check", res]);
       if (res){
         setState(() {
           isOk = true;
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



    // file_datesの日付のうち、新しいものから順に取得
    List<String> dates = file_dates.keys.toList()..sort();
    dates = dates.reversed.toList();
    // 画面横幅から、1/3の幅で、高さは4:3を想定
    double grid_width = MediaQuery.of(context).size.width;
    double solo_width = grid_width / 3;
    double solo_height = solo_width * 3/4;

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
          var intlist = Iterable<int>.generate((files.length~/3)+1).toList();
          var lastint = files.length~/3;
          var restint = files.length - 3 * lastint;
          var idxlist = intlist.map((idx){
            if (idx != lastint){
              return List<int>.generate(3, (int index){
                return 3 * idx + index;
              });
            }else{
              return List<int>.generate(3, (int index){
                if (index < restint){
                  return 3 * idx + index;
                }else{
                  return -1;
                }
              });
            }
          }).toList();
          // idxlistは[[0,1,2], [3, -1, -1]]のような、２次元配列
          // -1は画像が存在しないことを表す
          
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
                                            child: Image.asset(files[idx]),
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

