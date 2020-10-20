import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/services/auth_manage.dart';
import 'package:chat_app/services/home_manage.dart';

class Wrapper extends StatefulWidget {
  static String UID = '';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return ChangeNotifierProvider(
          create: (context) => AuthManage(), child: SplashScreen());
    } else {
      Wrapper.UID = user.id;
      return ChangeNotifierProvider(
          create: (context) => HomeManage(), child: HomeScreen());
    }
  }
}



