import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget screenButton (Color color, String text){
  return Container(
    alignment: Alignment.center,
    color: color,
    child: AutoSizeText(text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontFamily: "open_sans"
      )
    ),
  );
}