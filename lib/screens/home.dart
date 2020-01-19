import 'package:flutter/material.dart';
import 'package:huabang_application/models/dark.dart';
import 'package:huabang_application/models/id.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';



class HomePage extends StatefulWidget{
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  void onPressCameraButton(BuildContext context){
    if(validateID(controller.text) == null){
      print("after validation");
      Provider.of<ID>(context, listen: false).setID(controller.text);
      print("after set ID");
      Navigator.of(context).pushNamed('/camera');
      print("after screen change");
    }
  }

  void onPressViewerButton(BuildContext context){
    if(validateID(controller.text) == null){
      Provider.of<ID>(context, listen: false).setID(controller.text);
      Navigator.of(context).pushNamed('/gallery');
    }
  }

  void onPressConfigButton(BuildContext context){
    Navigator.of(context).pushNamed('/config');        
  }

  @override
  Widget build(BuildContext context) {  
    final List<Widget> icons = [
      IconButton(
        icon: Icon(Icons.settings),
        color: Theme.of(context).textTheme.button.color,
        onPressed: (){
          onPressConfigButton(context);
        },
      )
    ];

    print("make home widget");

    return WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
        appBar: CustomAppBar(height: 50, contents: icons),
        body: SingleChildScrollView(
          child: Container(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ID入力部分
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex:2,
                          child: Padding(
                            padding: EdgeInsets.only(top:3.0, left: 20.0, right: 10.0),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text("ID",
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "open_sans"
                                )
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex:5,
                          child: Padding(
                            padding: EdgeInsets.only(left:10.0, right:10.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: TextFormField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  errorStyle: TextStyle(
                                    fontSize: 10.0
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: validateID,
                                autovalidate: true,
                                style: new TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Roboto"
                                )                                
                              )
                            )
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
                      child: screenButton(Color(0xFF2D64B2), "Camera"),
                      onPressed: (){
                        onPressCameraButton(context);
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
                      child: screenButton(Color(0xFF2DB34A), "Viewer"),
                      onPressed: (){
                        onPressViewerButton(context);
                      },
                    ),
                  ),
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}