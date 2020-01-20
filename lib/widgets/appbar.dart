import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final List<Widget> contents;
  const CustomAppBar({Key key, @required this.height, this.contents});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: height,
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Image.asset('images/logo.png', fit: BoxFit.fitHeight),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Huabang Application",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "open_sans"
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: contents != null ?  contents :[Container()]
            ),
          )
        ],
      )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
