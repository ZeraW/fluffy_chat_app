import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MySizes mSize = MySizes(context);
    final getFriends = Provider.of<List<Friends>>(context);

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(mSize.getDesirableHeight(5)),
                topLeft: Radius.circular(mSize.getDesirableHeight(5)))),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(mSize.getDesirableHeight(5)),
              topLeft: Radius.circular(mSize.getDesirableHeight(5))),
          child: ListView.builder(
            itemCount: getFriends != null && getFriends.length > 0
                ? getFriends.length
                : 0,
            padding: EdgeInsets.only(top: mSize.getDesirableHeight(0.5)),
            itemBuilder: (context, index) {
              final Friends friends = getFriends[index];

              return rowChat(context, mSize, friends);
            },
          ),
        ),
      ),
    );
  }

/*
  */
  Widget rowChat(BuildContext context, MySizes mSize, Friends friends) {

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => StreamBuilder<DocumentSnapshot>(
                  stream: DatabaseService(streamId: friends.hisId).getUserById,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var getUser = snapshot.data.data;
                      if (getUser != null) {
                        return ChatScreen(
                            user: User.fromJson(getUser), room: friends.roomId);
                      } else {
                        return Text('');
                      }
                    } else {
                      return Text('');
                    }
                  }))),
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService(streamId: friends.roomId).getLastChatRoom,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var getLastChat = snapshot.data.data;

              ChatRoom lastChat = ChatRoom.fromJson(getLastChat);
              print('9999999999999999 ${lastChat.id}');
              return StreamBuilder<DocumentSnapshot>(
                  stream: DatabaseService(
                          streamId: friends.roomId, lastDoc: lastChat.lastChat)
                      .getLastChatDoc,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var getLastFluff = snapshot.data.data;

                      Fluff lastFluff = Fluff.fromJson(getLastFluff);
                      return Container(
                          margin: EdgeInsets.only(
                              top: mSize.getDesirableHeight(0.5),
                              bottom: mSize.getDesirableHeight(1.0),
                              right: mSize.getDesirableWidth(4.0)),
                          padding: EdgeInsets.symmetric(
                              horizontal: mSize.getDesirableWidth(3.2),
                              vertical: mSize.getDesirableHeight(1.5)),
                          decoration: BoxDecoration(
                              color: lastFluff.unread &&
                                      Wrapper.UID != lastFluff.sender
                                  ? Color(0xFFFFEFEE)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                      mSize.getDesirableHeight(3)),
                                  bottomRight: Radius.circular(
                                      mSize.getDesirableHeight(3)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<DocumentSnapshot>(
                                  stream: DatabaseService(
                                      streamId: friends.hisId)
                                      .getUserById,
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                      snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      var getUser = snapshot.data.data;

                                      return Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(mSize.getDesirableHeight(4.5)),
                                            child: FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              height: mSize.getDesirableHeight(9),
                                              width: mSize.getDesirableHeight(9),
                                              placeholder: 'assets/images/placeholder.png',
                                              image:  getUser['logo']!=null? getUser['logo']:'',
                                            ),
                                          ),
                                          SizedBox(
                                            width: mSize.getDesirableHeight(1.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: mSize
                                                      .getDesirableWidth(55.0),
                                                  child: Text(
                                                    getUser != null
                                                        ? getUser['name']
                                                        : '',
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                              SizedBox(
                                                /**/
                                                height: mSize.getDesirableHeight(1.0),
                                              ),
                                              SizedBox(
                                                  width: mSize.getDesirableWidth(50.0),
                                                  child: Text(lastFluff.text,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.blueGrey,
                                                          fontWeight:
                                                          FontWeight.w600))),
                                            ],
                                          )
                                        ],
                                      );
                                    } else {
                                      return Text('');
                                    }
                                  }),
                              Column(
                                children: [
                                  Text(
                                      timeago.format(
                                          new DateTime.now().subtract(
                                              DateTime.now()
                                                  .difference(lastFluff.time)),
                                          locale: 'en_short'),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: mSize.getDesirableHeight(1.0),
                                  ),
                                  lastFluff.unread &&
                                          Wrapper.UID != lastFluff.sender
                                      ? Container(
                                          height: mSize.getDesirableHeight(3.0),
                                          width: mSize.getDesirableWidth(11.0),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(mSize
                                                      .getDesirableHeight(3))),
                                          child: Text('NEW',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)))
                                      : Text('')
                                ],
                              )
                            ],
                          ));
                    } else {
                      return Text('');
                    }
                  });
            } else {
              return Text('');
            }
          }),
    );
  }
}
