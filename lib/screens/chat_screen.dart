import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatelessWidget {

  final User user;
  String room;

  ChatScreen({this.user, this.room});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Fluff>>.value(
      value: DatabaseService(streamId: room).getLiveFluff,
      child: ChatScreenX(user: user,room: room,),
    );
  }
}

class ChatScreenX extends StatefulWidget {
  final User user;
  String room;

  ChatScreenX({this.user, this.room});

  @override
  _ChatScreenXState createState() => _ChatScreenXState();
}

class _ChatScreenXState extends State<ChatScreenX> {
  _buildMessage(Fluff msg, bool isMe) {
    final msgContainer = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            timeago.format(new DateTime.now().subtract(DateTime.now().difference(msg.time)),locale: 'en'),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            msg.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return isMe
        ? msgContainer
        : Row(
            children: <Widget>[
              msgContainer,
              IconButton(
                icon: msg.isLiked
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                iconSize: 30.0,
                color: msg.isLiked
                    ? Theme.of(context).primaryColor
                    : Colors.blueGrey,
                onPressed: () {},
              )
            ],
          );
  }

  _buildMessageComposer() {
    String fluff = '';
    final TextEditingController _controller = new TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                fluff = value;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              Fluff newFluff = new Fluff(
                  sender: Wrapper.UID,
                  isLiked: false,
                  text: fluff,
                  unread: true,
                  time: Timestamp.now().toDate());

              await DatabaseService().postFluff(roomId: widget.room, fluff: newFluff, hisId: widget.user.id);

              await _controller.clear();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MySizes mSizes = MySizes(context);
    final getFluffs = Provider.of<List<Fluff>>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            '${widget.user.name}',
            style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
      StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService(streamId: 'friends.hisId').getUserById,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var getUser = snapshot.data.data;
            if (getUser != null) {
              IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onPressed: () {

                  });
            } else {
              return Text('');
            }
          }
          return Text('');
        }),

          ]),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: getFluffs!=null ?getFluffs.length : 0,
                    padding:
                        EdgeInsets.only(top: mSizes.getDesirableHeight(2.2)),
                    itemBuilder: (context, index) {
                      final Fluff msg = getFluffs[index];
                      bool isMe = msg.sender == Wrapper.UID;
                      return _buildMessage(msg, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer()
          ],
        ),
      ),
    );
  }
}
