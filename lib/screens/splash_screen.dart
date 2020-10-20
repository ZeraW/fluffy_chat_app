import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/services/auth_manage.dart';

import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    MySizes mSizes = MySizes(context);


    KeyboardVisibility.onChange.listen((bool visible) {
      Provider.of<AuthManage>(context,listen: false).toggleKeyboard(visible);
    });


    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        body: Stack(
              children: [
                Consumer<AuthManage>(
                    builder: (context, auth, child) {
                      return AnimatedContainer(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: Duration(milliseconds: 1000),
                          color: auth.backColor,
                          child: Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onTap: () {
                                      auth.toggleSplash(context,mSizes);
                                      print('koko');
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Fluffy Chat',
                                            style: TextStyle(
                                                fontSize: 28.0,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.bold,
                                                color: auth.titleColor),
                                          ),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          Text(
                                            'Welcome to Fluffy Chat, \n Please be nice to other people',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.w500,
                                                color: auth.headingColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: Container(
                                    width: 65.0,
                                    height: 65.0,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Material(color: Theme.of(context).primaryColor,
                                    child: InkWell(
                                      splashColor: Colors.blueGrey,
                                      onTap: () {
                                        //AuthManage.toggleLogin(context, mSizes);
                                        //print('haha');
                                        auth.toggleLogin(context, mSizes);
                                      },
                                      child: Container(
                                        height: 65.0,
                                        width: double.infinity,
                                        //color: Theme.of(context).primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Get Started',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                  }
                ),
                Consumer<AuthManage>(
                    builder: (context, auth, child) {
                      // 3mlt de hna 3lshan msh 3arf a7ot el init sizes fe el auth manage
                      double loYof = mSizes.getDesirableHeight(100);
                      double loWid = mSizes.getDesirableWidth(100);

                      if(auth.pageState == 0){
                        loYof = mSizes.getDesirableHeight(100);
                        loWid = mSizes.getDesirableWidth(100);

                      }else if (auth.keyVis &&auth.pageState==1){
                        loYof = 20.0;
                        loWid = auth.loginWidth;
                      }else {
                        loYof = auth.loginYOffset;
                        loWid = auth.loginWidth;
                      }

                      return AnimatedContainer(
                        padding: EdgeInsets.all(32),
                        height: auth.keyVis &&auth.pageState==1 ?
                        mSizes.getDesirableHeight(100)-20.0
                            : mSizes.getDesirableHeight(100)-auth.loginYOffset,
                        width: loWid,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 1000),
                        transform:
                            Matrix4.translationValues(auth.loginXOffset, loYof, 1),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(auth.loginOpacity),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(mSizes.getDesirableHeight(5)),
                                topLeft:
                                    Radius.circular(mSizes.getDesirableHeight(5)))),
                        child: LoginScreen(),
                      );
                  }
                ),
                Consumer<AuthManage>(
                    builder: (context, auth, child) {
                      return AnimatedContainer(
                        padding: EdgeInsets.all(32),
                        //ana 3mlt check el awl
                        height: auth.pageState==2?(auth.keyVis?mSizes.getDesirableHeight(100)-20:(mSizes.getDesirableHeight(100)-auth.registerOffset)):0,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 1000),
                        transform: Matrix4.translationValues(0,auth.keyVis &&auth.pageState==2 ? 20.0 :auth.registerOffset, 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(mSizes.getDesirableHeight(5)),
                                topLeft:
                                    Radius.circular(mSizes.getDesirableHeight(5)))),
                        child: RegisterScreen(),
                      );
                  }
                )
              ],
        ),
      ),
    );
  }
}
