import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';


class HomePage extends StatelessWidget {

  final List<Widget> icons = [
    IconButton(
      icon: Icon(Icons.settings),
      color: Colors.white,
      onPressed: (){
        print("Config");
      },
    )
  ];

  void onPressCameraButton(){
    print("Camera");
  }

  void onPressViewerButton(){
    print("Viewer");
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: CustomAppBar(height: 50, contents: icons),
      body: Container(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ID入力部分
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(top:10.0, left: 20.0, right: 10.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text("ID",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "open_sans"
                            )
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0, left:10.0, right:10.0),
                        child: TextFormField(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Cameraボタン部分
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  child: ScreenButton(Color(0xFF2D64B2), "Camera"),
                  onPressed: (){
                    onPressCameraButton();
                  },
                ),
              ),
            ),
            
            //ビューワボタン部分
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  child: ScreenButton(Color(0xFF2DB34A), "Viewer"),
                  onPressed: (){
                    onPressViewerButton();
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}