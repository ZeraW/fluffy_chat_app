import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MySizes mSize = MySizes(context);
    final getFriends = Provider.of<List<Friends>>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(mSize.getDesirableWidth(5),
              mSize.getDesirableHeight(2), mSize.getDesirableWidth(5),mSize.getDesirableHeight(1.5)),
          child: Text(
            'Favorite contacts',
            style: TextStyle(color: Colors.blueGrey,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0),
          ),
        ),
        Container(
          height: mSize.getDesirableHeight(14),
          child: ListView.builder(
            padding: EdgeInsets.only(left: mSize.getDesirableWidth(2.2)),
            itemCount: getFriends!=null?getFriends.length:0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Friends friends = getFriends[index];
              return StreamBuilder<DocumentSnapshot>(
                  stream: DatabaseService(streamId: friends.hisId).getUserById,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var getUser = snapshot.data.data;
                      if (getUser != null && friends.isFavorite) {
                        return GestureDetector(
                          onTap: () =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ChatScreen(
                                              user: User.fromJson(
                                                  getUser),
                                              room: friends.roomId))),
                          child: Container(
                            width: mSize.getDesirableHeight(12.0),
                            padding: EdgeInsets.only(
                                left: mSize.getDesirableWidth(1),
                                right: mSize.getDesirableWidth(1)),
                            child: Column(
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
                                  height: mSize.getDesirableHeight(0.5),
                                ),
                                Text(
                                  getUser['name'],
                                  style:
                                  TextStyle(color: Colors.blueGrey,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Text('');
                      }
                    } else {
                      return Text('');
                    }
                  }
              );
            },
          ),
        ),
      ],);
  }
}
