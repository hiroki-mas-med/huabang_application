import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:huabang_application/models/id.dart';
import 'package:huabang_application/models/ip4.dart';
import 'package:huabang_application/models/transfer.dart';
import 'package:huabang_application/other.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class CameraPage extends StatefulWidget{
  CameraPage({Key key}) : super(key: key);
  @override
  _CameraPageState createState() => new _CameraPageState();
}

class _CameraPageState extends State<CameraPage>{
  CameraController controller;
  CameraDescription camera;
  double zoom = 1.0;
  bool isAuto;
  String id;
  List<String> ip4;
  bool isUploading = false;
  String isNRL = "N";
  String url;
  String dirpath;
  StreamSubscription<HardwareButtons.VolumeButtonEvent> _volumeButtonSubscription;

  // 色合い
  Color eyeColor (){
    if (isUploading){
      return Colors.grey;
    }else if (isNRL == "N"){
      return Colors.white;
    }else if (isNRL == "R"){
      return Colors.red;
    }else{
      return Colors.lime;
    }
  }

  Color otherColor(){
    if (isUploading){
      return Colors.grey;
    }else{
      return Colors.white;
    }
  }

  Color outerColor(){
    if (isUploading){
      return Colors.grey;
    }else{
      return Theme.of(context).textTheme.button.color;
    }
  }


  void nextNRL(){
    if (isNRL == "N"){
      setState(() {
        isNRL = "R";
      });
    }else if (isNRL == "R"){
      setState(() {
        isNRL = "L";
      });
    }else if (isNRL == "L"){
      setState(() {
        isNRL = "N";
      });
    }
  }

  void onPressZoomInButton(){
    if (!isUploading){
      if (zoom < 5){
        setState(() {
          zoom += 0.5;
        });
       controller.setZoom(zoom);
        print(["zoom In", zoom]);
      }
    }
  }

  void onPressZoomOutButton(){
    if (!isUploading){
      if (zoom > 1){
        setState(() {
          zoom -= 0.5;
        });
        controller.setZoom(zoom);
        print(["zoom Out", zoom]);
       }
    }
  }

  void onPressTakePictureButton()async{
    await Directory(dirpath).create(recursive: true);
    print(dirpath);
    if (isUploading == false){
        // ここからが処理
      try{
        var dayfile = makeFileName(id, isNRL);
        var day = dayfile[0];
        var file = dayfile[1];
        Directory(dirpath).createSync(recursive: false);
        var fpath = '${dirpath}/${file}';
        print(["Save", id, day, file]);
        try{
          if(controller.value.isInitialized && !controller.value.isTakingPicture){
            await controller.takePicture(fpath);
            if (isAuto){
              setState(() {
                isUploading = true;
              });
              print(["Upload", id, day, file, fpath]);
              var uploadResult = await uploadFile(url, file, fpath);
              setState(() {
                isUploading = false;
              });
              if(!uploadResult){
                String err = "アップロードに失敗しました";
                stopDialog(err, context);
              }
            }
          }else{
            print("bad condition for take picture");
          }
        }catch(e){
          print("other error in take picture");
        }
      }catch(e){
        print(["undifined error", e]);
      }
    }
  }

  void onPressLRChangeButton(){
    if (!isUploading){
      nextNRL();
      print("LR change");
    }
  }

  void onPressGalleryButton(BuildContext context){
    if (!isUploading){
      Navigator.of(context).pushNamed('/gallery'); 
    }
  }

  void onPressConfigButton(BuildContext context){
    if(!isUploading){
      Navigator.of(context).pushNamed('/config'); 
    }
  }

  void onPressHomeButton(BuildContext context){
    if(!isUploading){
      Navigator.of(context).pushNamed('/'); 
    }
  }


  Future<void> initFunction()async{
    // Providerのデータ読み込みおよび反映
    id = Provider.of<ID>(context, listen: false).value;
    ip4 = Provider.of<IP4>(context, listen: false).value;      
    setState(() {
      isAuto = Provider.of<Transfer>(context, listen:false).value;
    });

    _volumeButtonSubscription = HardwareButtons.volumeButtonEvents.listen((event) {
      setState((){
        onPressTakePictureButton();
      });
    });

    // Camera画面
    List<CameraDescription> cameras = await availableCameras();
    camera = cameras[0];
    controller = CameraController(camera, ResolutionPreset.ultraHigh);
    await controller.initialize();
    if (!mounted) {
      return;
    }  
    setState(() {});
    // Directoryの準備
    var path = await camerapath();
    dirpath = '${path}/${id}';


    // AutoおよびIPアドレスのチェック
    if(isAuto){
      if(checkIP4(ip4)==true){
        // IPアドレスからURLに変換し、
        var url_tmp = convertip2url(ip4);
        // テスト中のために、Upload中にする
        setState(() {
          isUploading = true;
        });
        // ３秒というタイムリミットの中、接続を行う
        var checkresult = await testWiFi(url_tmp);
        // 結果のいかんにせよ、Upload中を切る。
        setState(() {
          isUploading = false;
        });
        // 結果が良ければ、正式なURLに代入する
        // 悪けれあば、エラーダイアログ
        if(checkresult){
          url = url_tmp + "/image";
        }else{
          String err = "転送先のURLを確認しましたが、接続できません";
          // 何かしらのエラーダイアログ、Homeボタンか、Configボタン
          errorDialog(err, context);
        }
      }else{
        // IPアドレスにNoneが入っていた場合を想定
        // 何かしらのエラーダイアログ
        String err = "自動転送モードに設定されているにも関わらず、IP Addressが不正です";
        errorDialog(err, context);
          // 何かしらのエラーダイアログ、Homeボタンか、Configボタン
      }
    }else{
      print("自動転送モードではありません、よろしいでしょうか？");
      confirmDialog(context);
    }


  }

  @override
  void initState() {
    super.initState();
    // initState内で非同期処理をしたい場合は、この書き方がもっとも簡便？
    new Future.delayed(Duration.zero, () {
      initFunction();
    });
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context){
    double all_height = MediaQuery.of(context).size.height;
    double height = all_height/3;
    double width = all_height/5;

    Widget cameraScreen(BuildContext context, CameraController controller){
      try{
        if (controller.value.isInitialized){
          return RotatedBox(
            quarterTurns: 3,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller)
            ),
          );
        }else{
          return Container();
        }
      }catch(e){
        return Container();
      }
    }

    Widget upLoadingContent(){
      if (isUploading){
        return Container(
          alignment:Alignment.centerLeft,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height * 4 /3,
            child: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
              ),
            ),
          ),
        );
      }else{
        return Container();
      }
    }


    return Scaffold(
      body:  Stack(
        children: <Widget>[
          // 後ろの写真
          Container(
            alignment: Alignment.centerLeft,
            //child: cameraScreen(context, controller),
            child: cameraScreen(context, controller),
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
                          icon: Icon(Icons.zoom_in, 
                            color: zoom < 5 ? otherColor(): Colors.grey, 
                            size: width/2
                          ),
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
                          icon: Icon(Icons.zoom_out, 
                            color: zoom > 1 ? otherColor(): Colors.grey, 
                            size: width/2
                          ),
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
                icon: Icon(Icons.photo_camera, 
                  color: otherColor(), 
                  size: width/2
                ),
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
                              child: AutoSizeText(isNRL, 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: eyeColor(), 
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
                              icon: Icon(Icons.remove_red_eye, color: eyeColor(), size: width/2,),
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
                        icon: Icon(Icons.photo_library,
                         color: otherColor(), 
                         size: width/2
                        ),
                        onPressed: (){
                          onPressGalleryButton(context);
                        },
                      ),
                    ),              
                  ),

                ],
              ),
            ),
          ),
          // 処理中のCircular
          upLoadingContent(),
          // 右上のHome Button
          Container(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.centerLeft,
              height: width,
              width: width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.home, 
                        color: outerColor(), 
                        size: width/2
                      ),
                      onPressed: (){
                        onPressHomeButton(context);
                      },
                    ),
                  ),
                ],
              )
            ),
          ),
          // ここまでCameraButton

        ],
      )      
    );
  }
}


