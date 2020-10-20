import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utils.dart';
import 'package:chat_app/widgets/favorites_contacts.dart';
import 'package:chat_app/widgets/recent_chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Friends>>.value(
      value: DatabaseService().getLastChatUser,
      child: Column(
        children: [FavoritesContacts(), RecentChats()],
      ),
    );
  }
}

class OnlineTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Friends>>.value(
        value: DatabaseService().getCurrentFriends, child: OnlineXTab());
  }
}

class OnlineXTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MySizes mSize = MySizes(context);
    final getFriends = Provider.of<List<Friends>>(context);

    return Container(
      child: ListView.builder(
        //reverse: true,
        itemCount:
            getFriends != null && getFriends.length > 0 ? getFriends.length : 0,
        padding: EdgeInsets.only(top: mSize.getDesirableHeight(2.2)),
        itemBuilder: (context, index) {
          final Friends friends = getFriends[index];

          //bool isMe = msg.sender.id == currentUser.id;
          return GestureDetector(
            onTap: () {},
            child: rowRequest(friends.hisId, friends.roomId),
          );
        },
      ),
    );
  }

  Widget rowRequest(String id, String roomId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService(streamId: id).getUserById,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var getUser = snapshot.data.data;
              if (getUser != null) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatScreen(
                              user: User.fromJson(getUser), room: roomId))),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              height: 50.0,
                              width: 50.0,
                              placeholder: 'assets/images/placeholder.png',
                              image:  getUser['logo']!=null? getUser['logo']:'',
                            ),
                          ),
                          getUser['status']
                              ? Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                      radius: 11.5,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor: Colors.green,
                                      )),
                                )
                              : Text('')
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        getUser['name'],
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('');
              }
            } else {
              return Text('');
            }
          }),
    );
  }
}

class RequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Friends>>.value(
        value: DatabaseService().getFriendRequests, child: RequestsXTab());
  }
}

class RequestsXTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MySizes mSize = MySizes(context);
    final getFriends = Provider.of<List<Friends>>(context);

    return Container(
      child: ListView.builder(
        //reverse: true,
        itemCount:
            getFriends != null && getFriends.length > 0 ? getFriends.length : 0,
        padding: EdgeInsets.only(top: mSize.getDesirableHeight(2.2)),
        itemBuilder: (context, index) {
          final Friends friends = getFriends[index];

          //bool isMe = msg.sender.id == currentUser.id;
          return GestureDetector(
            onTap: () {},
            child: rowRequest(friends.hisId),
          );
        },
      ),
    );
  }

  Widget rowRequest(String id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService(streamId: id).getUserById,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var getUser = snapshot.data.data;
              if (getUser != null) {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                        placeholder: 'assets/images/placeholder.png',
                        image:  getUser['logo']!=null? getUser['logo']:'',
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getUser['name'],
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            RaisedButton(
                              onPressed: () async {
                                await Firestore.instance
                                    .collection('Users')
                                    .document(Wrapper.UID)
                                    .collection('friends')
                                    .document(id)
                                    .updateData({'isFriend': 1});
                                await Firestore.instance
                                    .collection('Users')
                                    .document(id)
                                    .collection('friends')
                                    .document(Wrapper.UID)
                                    .updateData({'isFriend': 1});
                              },
                              color: Colors.red,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  side: BorderSide(color: Colors.red)),
                              padding: EdgeInsets.all(8.0),
                              child: Text('Confirm',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RaisedButton(
                              onPressed: () {},
                              color: Colors.grey,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  side: BorderSide(color: Colors.grey)),
                              padding: EdgeInsets.all(8.0),
                              child: Text('Delete',
                                  style: TextStyle(fontSize: 16)),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                );
              } else {
                return Text('');
              }
            } else {
              return Text('');
            }
          }),
    );
  }
}
