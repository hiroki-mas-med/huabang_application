import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home.dart';
import 'screens/config.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // CameraやStorageの許可
  // 画面を横向きに
  await setOrientation();
  print("loaded");
  runApp(
    MyApp()
  );
} 

Future<void> setOrientation() async{
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIOverlays ([]);
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Huabang Application",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xff00bfff),
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/config": (context) => ConfigPage(),
      }
    );
  }
}
