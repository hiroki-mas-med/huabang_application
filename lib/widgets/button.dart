import 'package:flutter/material.dart';


Widget ScreenButton (Color color, String text){
  return Container(
    alignment: Alignment.center,
    color: color,
    child: Text(text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontFamily: "open_sans"
      )
    ),
  );
}