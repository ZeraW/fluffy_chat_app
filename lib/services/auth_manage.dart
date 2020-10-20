import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthManage extends ChangeNotifier {
  int pageState = 0;
  Color backColor = Colors.white;
  Color titleColor = Colors.blueGrey;
  Color headingColor = Colors.grey;
  double loginYOffset = 0;
  double loginXOffset = 0;
  double loginWidth = 0;
  double registerOffset =0;
  double loginOpacity = 1;
  bool keyVis = false;

  void toggleSplash(BuildContext context,MySizes mSizes) {
    print("object");
    pageState = 0;
    //change the color of mail background
    backColor = Colors.white;
    //change the color of title and desc
    titleColor = Colors.blueGrey;
    headingColor = Colors.grey;
    //change the height of login and register screen
    loginYOffset = mSizes.getDesirableHeight(100);
    loginXOffset = mSizes.getDesirableWidth(0);
    loginWidth = mSizes.getDesirableWidth(100);
    loginOpacity = 1;
    registerOffset = mSizes.getDesirableHeight(100);
    notifyListeners();
  }

  void toggleLogin(BuildContext context,MySizes mSizes) {
    print("object");
    pageState = 1;
    //change the color of mail background
    backColor = Theme.of(context).primaryColor;
    //change the color of title and desc
    titleColor = Colors.white;
    headingColor = Colors.white;
    //change the height of login and register screen
    loginYOffset = mSizes.getDesirableHeight(30);
    loginXOffset = mSizes.getDesirableWidth(0);
    loginWidth = mSizes.getDesirableWidth(100);
    registerOffset = mSizes.getDesirableHeight(100);
    loginOpacity = 1;
    notifyListeners();
  }

  void toggleRegister(BuildContext context,MySizes mSizes) {
    pageState = 2;
    //change the color of mail background
    backColor = Theme.of(context).primaryColor;
    //change the color of title and desc
    titleColor = Colors.white;
    headingColor = Colors.white;
    //change the height of login and register screen
    loginYOffset = mSizes.getDesirableHeight(30);
    loginXOffset = mSizes.getDesirableWidth(5);
    loginWidth = mSizes.getDesirableWidth(100) - mSizes.getDesirableWidth(10);
    registerOffset = mSizes.getDesirableHeight(35);
    loginOpacity = 0.7;
    notifyListeners();
  }


  void toggleKeyboard(bool input) {
   keyVis = input;
   notifyListeners();
  }
}
