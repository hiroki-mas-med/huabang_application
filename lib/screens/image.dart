import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';



class ImagePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    File file = ModalRoute.of(context).settings.arguments;
    return PhotoView(
      imageProvider: FileImage(file),
      initialScale: PhotoViewComputedScale.contained,
      customSize: MediaQuery.of(context).size,
      minScale: PhotoViewComputedScale.contained * 1.0,
      maxScale: PhotoViewComputedScale.contained * 4.0,
    );
  }
}
