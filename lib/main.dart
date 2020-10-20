
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:chat_app/models/db_model.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Color(0xFFFEF9EB),
        canvasColor: Colors.transparent,

      ),
      home: SafeArea(
        child: StreamProvider<User>.value(
            value: AuthService().user, child: Wrapper()),
      ),
    );
  }
}