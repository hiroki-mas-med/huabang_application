import 'package:flutter/material.dart';
import 'package:huabang_application/models/dark.dart';
import 'package:huabang_application/models/ip4.dart';
import 'package:huabang_application/models/transfer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import 'package:auto_size_text/auto_size_text.dart';



class ConfigPage extends StatefulWidget{
  ConfigPage({Key key}) : super(key: key);
  @override
  _ConfigPageState createState() => new _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool isAuto = false;
  bool isDark = false;
  List<String> ip4 = List.generate(4, (i) => null);
  List<TextEditingController> controllers = List.generate(4, (i)=>TextEditingController());

  void onPressedTransferButton(){
    setState(() {
      isAuto = !isAuto;
    });    
  }

  void onPressedDarkModeButton(){
    setState(() {
      isDark = !isDark;
    });
  }

  void onPressOKButton(BuildContext context)async{
    var prefs = await SharedPreferences.getInstance();
    ip4 = controllers.map((controller){
      return controller.text;
    }).toList();
    if (checkIP4(ip4)){
      Provider.of<IP4>(context, listen: false).setIP4(ip4);
      await prefs.setStringList("ip4", ip4);
    }
    Provider.of<Transfer>(context, listen: false).setTransfer(isAuto);
    await prefs.setBool("transfer", isAuto);
    Provider.of<Dark>(context, listen: false).setDark(isDark);
    await prefs.setBool("dark", isDark);
    Navigator.of(context).pushNamed('/');
  }

  void onPressHomeButton(BuildContext context){
    Navigator.of(context).pushNamed("/");
  }


  Color autoColor(){
    if (isAuto){
      return Colors.blue;
    }else{
      return Theme.of(context).textTheme.button.color;
    }
  }

  Color darkColor(){
    if (isDark){
      return Colors.blue;
    }else{
      return Theme.of(context).textTheme.button.color;
    }
  }



  List<Widget> iPAddressForm(){
    return [
      Expanded(
        flex: 3,
        child: TextFormField(
          controller: controllers[0],
          decoration: const InputDecoration(
            errorStyle: TextStyle(
              fontSize: 10.0
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: validateIP,
          autovalidate: true,
          style: new TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w300,
            fontFamily: "Roboto"),
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(".",
            style: TextStyle(
              // color: Colors.black,
              fontSize: 25.0,
              fontFamily: "open_sans"                                    
            ),
          ),
        ),
      ),

      Expanded(
        flex: 3,
        child: TextFormField(
          controller: controllers[1],
          decoration: const InputDecoration(
            errorStyle: TextStyle(
              fontSize: 10.0
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: validateIP,
          autovalidate: true,
          style: new TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w300,
            fontFamily: "Roboto"),
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(".",
            style: TextStyle(
              // color: Colors.black,
              fontSize: 25.0,
              fontFamily: "open_sans"                                    
            ),
          ),
        ),
      ),

      Expanded(
        flex: 3,
        child: TextFormField(
          controller: controllers[2],
          decoration: const InputDecoration(
            errorStyle: TextStyle(
              fontSize: 10.0
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: validateIP,
          autovalidate: true,
          style: new TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w300,
            fontFamily: "Roboto"),
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(".",
            style: TextStyle(
              // color: Colors.black,
              fontSize: 25.0,
              fontFamily: "open_sans"                                    
            ),
          ),
        ),
      ),

      Expanded(
        flex: 3,
        child: TextFormField(
          controller: controllers[3],
          decoration: const InputDecoration(
            errorStyle: TextStyle(
              fontSize: 10.0
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: validateIP,
          autovalidate: true,
          style: new TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w300,
            fontFamily: "Roboto"),
        ),
      ),
    ];
  }

  @override
  void initState() {
    setState(() {
      isAuto = Provider.of<Transfer>(context, listen:false).value;
      isDark = Provider.of<Dark>(context, listen:false).value;
      ip4 = Provider.of<IP4>(context, listen: false).value;
      for (int idx = 0; idx < 4; idx++) {
        // 初期値としてcontroller.textにipsformの値(当初は読み取ったipsと同じ値)を代入
        controllers[idx].text = ip4[idx];
      }
    }); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> icons = [
      IconButton(
        icon: Icon(Icons.home),
        // color: Colors.white,
        onPressed: (){
          onPressHomeButton(context);
        },
      ),    
    ];

    return Scaffold(
      appBar: CustomAppBar(height: 50, contents: icons),
      body: SingleChildScrollView(
        child: Container(
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
                                // color: Colors.black,
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
                            children: iPAddressForm()
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
                                // color: Colors.black,
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
                              color: autoColor(),
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
                                // color: Colors.black,
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
                              color: darkColor(),
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
                    child: screenButton(Color(0xFF2D64B2), "OK"),
                    onPressed: (){
                      onPressOKButton(context);
                    },
                  ),
                )
              ),

            ],
          )
        ),
      )
    );
  }
}