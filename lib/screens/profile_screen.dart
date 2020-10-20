import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snapshot = Provider.of<DocumentSnapshot>(context);

    User user = snapshot != null ? new User.fromJson(snapshot.data) : null;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Profile'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          children: [
            SizedBox(
              height: 35.0,
            ),
            Stack(
              children: [
                Hero(
                  tag: 'profileTag',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      height: 200,
                      width: 200,
                      placeholder: 'assets/images/placeholder.png',
                      image: user != null && user.logo != null ? user.logo : '',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: () async {
                        print('object');
                        await DatabaseService().uploadPic(user.id);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.camera_alt,
                          size: 27,
                          color: Colors.white,
                        ),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              leading: Icon(
                Icons.person,
                size: 33,
                color: Colors.blueGrey,
              ),
              title: Text(
                'Name',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user != null ? user.name : '',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                ],
              ),
              trailing: Icon(Icons.edit,
                  color: Theme.of(context).primaryColor, size: 28),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              leading: Icon(
                Icons.phone,
                size: 33,
                color: Colors.blueGrey,
              ),
              title: Text(
                'Phone',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey),
              ),
              subtitle: Text(user != null ? user.phone : '',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey)),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async{
                await AuthService().signOut(context);
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                height: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.exit_to_app,size: 35,color: Colors.white,),
                    SizedBox(width: 10.0,),
                    Text('Sign Out ',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.white))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*class ProfileFivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color color2 = Colors.purple;
    final Color color1 = Colors.red;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [color1, color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                */ /*Text("Date mate", style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontStyle: FontStyle.italic
                ),),*/ /*
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text("Online"),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Sasha Michel",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 1.0),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      size: 18.0,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "01020304059",
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 16,
                          color: Colors.grey.shade600),
                    )
                  ],
                ),
                SizedBox(height: 70.0),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 16.0),
                        margin: const EdgeInsets.only(
                            top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color1, color2],
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.clear),
                              onPressed: () {},
                            ),
                            Spacer(),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.message),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.pink,
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ],
      ),
    );
  }
}*/
