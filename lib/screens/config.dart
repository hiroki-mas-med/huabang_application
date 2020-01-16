import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import 'package:auto_size_text/auto_size_text.dart';


class ConfigPage extends StatelessWidget {

  void onPressedTransferButton(){
    print("Auto Transfer");    
  }

  void onPressedDarkModeButton(){
    print("Dark Mode");
  }

  void onPressOKButton(){
    print("OK");
  }



  List<Widget> IPAddressForm(){
    return [
      Expanded(
        flex: 3,
        child: TextFormField(),
      ),
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(".",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: "open_sans"                                    
            ),
          ),
        ),
      ),

      Expanded(
        flex: 3,
        child: TextFormField(),
      ),
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(".",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: "open_sans"                                    
            ),
          ),
        ),
      ),

      Expanded(
        flex: 3,
        child: TextFormField(),
      ),
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(".",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: "open_sans"                                    
            ),
          ),
        ),
      ),

      Expanded(
        flex: 3,
        child: TextFormField(),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: CustomAppBar(height: 50),
      body: Container(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // IPアドレス
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top:10.0, left: 20.0, right: 10.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text("IP Address",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "open_sans"
                            )
                          ),
                        ),
                      ),                  
                    ),

                    // IPアドレス記入欄
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(bottom:10.0, left: 10.0, right: 10.0),
                        child: Row(
                          children: IPAddressForm()
                        )
                      )
                    ),                
                  ],
                ),
              )
            ),  
            
            // 自動転送
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: AutoSizeText("Auto Transfer",
                            textAlign: TextAlign.center,
                            style: TextStyle(                              
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: "open_sans"
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            alignment: AlignmentDirectional.center,
                            icon: Icon(Icons.file_upload, size: 35.0),
                            color: Colors.black,
                            onPressed: (){
                              onPressedTransferButton();
                            },
                          )
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),   


            // Dark Mode
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: AutoSizeText("Dark Mode",
                            textAlign: TextAlign.center,
                            style: TextStyle(                              
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: "open_sans"
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            alignment: AlignmentDirectional.center,
                            icon: Icon(Icons.colorize, size: 35.0),
                            color: Colors.black,
                            onPressed: (){
                              onPressedDarkModeButton();
                            },
                          )
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),   

            // OKボタン
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  child: ScreenButton(Color(0xFF2D64B2), "OK"),
                  onPressed: (){
                    onPressOKButton();
                  },
                ),
              )
            ),


          ],
        )
      ),
    );
  }
}