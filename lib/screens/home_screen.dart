import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/home_tabs.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/home_manage.dart';
import 'package:chat_app/utils.dart';
import 'package:chat_app/widgets/category_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Firestore.instance.collection('Users')
        .document(Wrapper.UID)
        .updateData({'status': true});
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //TODO: set status to online here in firestore
      print('hi');
      Firestore.instance.collection('Users')
          .document(Wrapper.UID)
          .updateData({'status': true});
    } else {
      //TODO: set status to offline here in firestore
      print('bye');
      Firestore.instance.collection('Users')
          .document(Wrapper.UID)
          .updateData({'status': false});
    }
  }

  @override
  Widget build(BuildContext context) {
    MySizes mSize = MySizes(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: bodyForHome(mSize),
    );
  }

  Widget appBarForHome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0 ,left: 20.0,top: 12.0),
      child: Row(children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => StreamProvider<DocumentSnapshot>.value(
                        value: DatabaseService(streamId: Wrapper.UID).getUserById,
                        child: MyProfile())));
            // await AuthService().signOut(context);
          } ,
          child: StreamBuilder<DocumentSnapshot>(
              stream: DatabaseService(streamId: Wrapper.UID).getUserById,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var getUser = snapshot.data.data;
                  if (getUser != null) {
                    return Hero(
                      tag: 'profileTag',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                          placeholder: 'assets/images/placeholder.png',
                          image:  getUser['logo']!=null? getUser['logo']:'',
                        ),
                      ),
                    );
                  } else {
                    return Text('');
                  }
                } else {
                  return Text('');
                }
              }),
        ),
        SizedBox(width: 20.0,),
        Text(
          'Chats',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        Spacer(),
        IconButton(
            icon: Icon(
              Icons.search,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                          create: (context) => HomeManage(),
                          child: SearchScreen())));
            })
      ],),
    );

  }

  Widget bodyForHome(MySizes mSize) {
    return Column(
      children: [
        appBarForHome(context),
        CategorySelector(),
        Consumer<HomeManage>(builder: (context, home, child) {
          return Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: home.currentPage ==0 ?Theme.of(context).accentColor : Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(mSize.getDesirableHeight(5)),
                      topLeft: Radius.circular(mSize.getDesirableHeight(5)))),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(mSize.getDesirableHeight(5)),
                      topLeft: Radius.circular(mSize.getDesirableHeight(5))),
                  child: home.currentTab(home.currentPage)),
            ),
          );
        })
      ],
    );
  }
}
