import 'dart:io';

import 'package:flutter/material.dart';

class MyColors {
  Color mainColor = Colors.amber;
  Color accentColor = Colors.amberAccent;
  Color offWhite = Color(0xffF1F1F1);
  Color black = Colors.black;
}

class EnStrings {
  String appName = "ResUi";
}

class ArStrings {
  String appName;
  String whatever;
}

class MySizes {
  BuildContext _context;
  MySizes(this._context);

  getDesirableWidthX(double percent) {
    return MediaQuery.of(_context).size.width * (percent / 100);
  }

  getDesirableHeightX(double percent) {
    return MediaQuery.of(_context).size.height * (percent / 100);
  }

  getDesirableWidth(double percent) {
      return MediaQuery.of(_context).orientation == Orientation.portrait
          ? MediaQuery.of(_context).size.width * (percent / 100)
          : getDesirableHeightX(percent);
  }

  getDesirableHeight(double percent) {
      return MediaQuery.of(_context).orientation == Orientation.portrait
          ? MediaQuery.of(_context).size.height * (percent / 100)
          : getDesirableWidthX(percent);
  }




}

