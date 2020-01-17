import 'package:flutter/material.dart';
import '../widgets/appbar.dart';


class GalleryPage extends StatelessWidget {
  

  final Map<String, List<String>> file_dates = {
    "2019/11/24": ["images/sample.jpeg", "images/sample.jpeg"],
    "2020/12/24": ["images/sample.jpeg", "images/sample.jpeg", "images/sample.jpeg", "images/sample.jpeg"]
  };

  void onPressUploadButton(BuildContext context){
    print("Upload");
    Navigator.of(context).pushNamed('/');        
  }

  void onPressConfigButton(BuildContext context){
    print("Config");
    Navigator.of(context).pushNamed('/config');        
  }

  void onPressImageButton(BuildContext context, String fpath){
    Navigator.of(context).pushNamed('/image', arguments: fpath);
  }

  void onLongPressImageButton(){
    print("Long press");
  }



  @override
  Widget build(BuildContext context) {

    // AppBarに表示するためのIcon
    final List<Widget> icons = [
      IconButton(
        icon: Icon(Icons.file_upload),
        // color: Colors.white,
        onPressed: (){
          onPressUploadButton(context);
        },
      ),    
      IconButton(
        icon: Icon(Icons.settings),
        // color: Colors.white,
        onPressed: (){
          onPressConfigButton(context);
        },
      ),
    ];



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
                                        color: Colors.blue,
                                        child: GestureDetector(
                                          onTap: (){
                                            onPressImageButton(context, files[idx]);
                                          },
                                          onLongPress: (){
                                            onLongPressImageButton();
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
      body: SingleChildScrollView(
        child: Column(
          children: contents()
        ),
      )
    );
  }
}

