import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huabang_application/models/dark.dart';
import 'package:huabang_application/models/id.dart';
import 'package:huabang_application/models/ip4.dart';
import 'package:huabang_application/models/transfer.dart';
import 'package:huabang_application/other.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/config.dart';
import 'screens/image.dart';
import 'screens/camera.dart';
import 'screens/gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // CameraやStorageの許可
  // 画面を横向きに
  await setOrientation();
  // CameraやStorageの許可
  await permission();
  // IPアドレスの読み込み
  List<String> ip4 = await readip4();
  bool transfer = await readTransfer();
  bool dark = await readDark();
  
  print("permission OK");
  // データ保存先作成
  String path = await camerapath();
  //final Directory extDir = await Dictionary(camerapath());
  //String path = '${extDir.path}/Pictures';
  print(path);
  await Directory(path).create(recursive: true);


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ID>(
          create: (_)=> ID(),
        ),
        ChangeNotifierProvider<IP4>(
          create: (_)=> IP4(ip4),
        ),
        ChangeNotifierProvider<Transfer>(
          create: (_)=> Transfer(transfer),
        ),
        ChangeNotifierProvider<Dark>(
          create: (_)=> Dark(dark),
        ),
      ],
      child: MyApp(),
    )
  );
} 




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Huabang Application",
      theme: ThemeData(
        brightness: appBrightness(Provider.of<Dark>(context).value),
        primaryColor: const Color(0xff00bfff),
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/config": (context) => ConfigPage(),
        "/image": (context) => ImagePage(),
        "/camera": (context) => CameraPage(),
        "/gallery": (context) => GalleryPage(),
      }
    );
  }
}


Brightness appBrightness(bool isDark){
  if(!isDark){
    return Brightness.light;
  }else{
    return Brightness.dark;
  }
}

Future<void> setOrientation() async{
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIOverlays ([]);
}

Future<void> permission()async{
  var res0 = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  var res1 = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  if(res0[PermissionGroup.camera] == PermissionStatus.denied){
    exit(0);
  }
  if(res1[PermissionGroup.storage] == PermissionStatus.denied){
    exit(0);
  }
}
