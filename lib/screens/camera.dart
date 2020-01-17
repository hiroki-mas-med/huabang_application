import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CameraPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    double all_height = MediaQuery.of(context).size.height;
    double height = all_height/3;
    double width = all_height/5;

    void onPressZoomInButton(){
      print("zoom In");
    }

    void onPressZoomOutButton(){
      print("zoom Out");
    }

    void onPressTakePictureButton(){
      print("Take a photo");
    }

    void onPressLRChangeButton(){
      print("LR change");
    }

    void onPressGalleryButton(BuildContext context){
      Navigator.of(context).pushNamed('/gallery');        
    }

    return Scaffold(
      body:  Stack(
        children: <Widget>[
          // 後ろの写真
          Container(
            alignment: Alignment.centerLeft,
            child: Image.asset("images/sample.jpeg"),
          ),

          // 左上のズームインとアウト
          Padding(
            padding: EdgeInsets.only(top: 10,),
            child: Container(
              alignment: Alignment.topLeft,
              child: Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(                          
                          icon: Icon(Icons.zoom_in, color: Colors.white, size: width/2),
                          onPressed: (){
                            onPressZoomInButton();
                          },
                        ),
                      ),              
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.zoom_out, color: Colors.white, size: width/2),
                          onPressed: (){
                            onPressZoomOutButton();
                          },
                        ),
                      ),              
                    ),
                  ],                
                ),
              ),
            )
          ),
          // ここまでzoom InとOut画面
          
          // Camera Button
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: Alignment.centerLeft,
              height: width,
              width: width,
              child: IconButton(
                icon: Icon(Icons.photo_camera, color: Colors.white, size: width/2),
                onPressed: (){
                  onPressTakePictureButton();
                },
              ),
            ),
          ),
          // ここまでCameraButton

          // ここまでLR指示ボタン、ピッカーボタン
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: height,
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // LRの文字とボタン
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        // 文字
                        Expanded(
                          flex:1,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              // ここの1.4は手動合わせ
                              width: width*1.4/2,
                              child: AutoSizeText("R", 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: width, 
                                  fontFamily: "Roboto"
                                ),
                              ),
                            ),
                          ),
                        ),
                        // ボタン
                        Expanded(
                          flex:2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Colors.white, size: width/2,),
                              onPressed: (){
                                onPressLRChangeButton();
                              },
                            )
                          )  
                        ),
                      ],
                    )         
                  ),
                  // ここまで文字とボタン
                  
                  // ここからギャラリーボタン
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.photo_library, color: Colors.white, size: width/2),
                        onPressed: (){
                          onPressGalleryButton(context);
                        },
                      ),
                    ),              
                  ),

                ],
              ),
            ),
          )
        ],
      )      
    );
  }
}


