import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/home_manage.dart';
import 'package:chat_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeManage>(builder: (context, home, child) {
      return StreamProvider<List<User>>.value(
          value: DatabaseService().getUsers(home.searchPhoneNumber),
          child: SearchXScreen());
    });
  }
}

class SearchXScreen extends StatefulWidget {
  @override
  _SearchXScreenState createState() => _SearchXScreenState();
}

class _SearchXScreenState extends State<SearchXScreen> {
  String searchInput = '';

  double clearOpacity = 0.0;
  final TextEditingController _controller = new TextEditingController();

  Widget build(BuildContext context) {
    final getUser = Provider.of<List<User>>(context);
    MySizes mSize = MySizes(context);
    return StreamProvider<List<User>>.value(
      value: DatabaseService().getUsers(''),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Container(
            child: Column(
              children: [
                Container(
                  height: mSize.getDesirableHeight(10.0),
                  width: mSize.getDesirableWidth(100),
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: _searchBar(),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight:
                                Radius.circular(mSize.getDesirableHeight(5)),
                            topLeft:
                                Radius.circular(mSize.getDesirableHeight(5)))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight:
                              Radius.circular(mSize.getDesirableHeight(5)),
                          topLeft:
                              Radius.circular(mSize.getDesirableHeight(5))),
                      child: ListView.builder(
                        //reverse: true,
                        itemCount: getUser != null && getUser.length > 0
                            ? getUser.length
                            : 0,
                        padding:
                            EdgeInsets.only(top: mSize.getDesirableHeight(2.2)),
                        itemBuilder: (context, index) {
                          final User user = getUser[index];

                          //bool isMe = msg.sender.id == currentUser.id;
                          return GestureDetector(
                            onTap: () {
                              _modalBottomSheetMenu(
                                  mSize.getDesirableHeight(60), user);
                            },
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(mSize.getDesirableHeight(4.5)),
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  height: mSize.getDesirableHeight(9),
                                  width: mSize.getDesirableHeight(9),
                                  placeholder: 'assets/images/placeholder.png',
                                  image:  user.logo!=null? user.logo:'',
                                ),
                              ),
                              title: Text(
                                user.name,
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          resizeToAvoidBottomPadding: false,
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (val) {
              Provider.of<HomeManage>(context, listen: false)
                  .queryPhoneNumber(val);
              setState(() {
                searchInput = val;
                val.isEmpty ? clearOpacity = 0 : clearOpacity = 1;
              });
            },
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Opacity(
          opacity: clearOpacity,
          child: IconButton(
            icon: Icon(
              Icons.clear,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: () {
              _controller.clear();
              setState(() {
                clearOpacity = 0;
              });
            },
          ),
        ),
      ],
    );
  }

  void _modalBottomSheetMenu(double height, User user) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: height,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  child: Column(
                    children: [
                      Expanded(
                          child: Stack(
                        children: [
                          Container(
                            height: 120.0,
                            color: Colors.red,
                          ),
                          Positioned(
                            top: 60.0,
                            left: 0.0,
                            right: 0.0,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 63.0,
                                  child: Container(
                                    width: 120.0,
                                    height: 120.0,
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        //border: Border.all(color: Colors.white, width: 4),
                                        borderRadius: BorderRadius.circular(60.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      height: 120.0,
                                      width: 120.0,
                                      placeholder: 'assets/images/placeholder.png',
                                      image:  user.logo!=null? user.logo:'',
                                    ),
                                  ),),
                                ),
                                SizedBox(height: 10.0,),
                                Text(user.name,style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 22.0),),
                                SizedBox(height: 10.0,),
                                Text(user.phone,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 17.0),)
                              ],
                            ),
                          )
                        ],
                      )),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: DatabaseService(streamId: user.id).isFriend,
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              var getUser = snapshot.data.data;

                              if(getUser!= null){
                                int checker = getUser['isFriend'];
                                String status = '';
                                if(checker ==0 ){
                                  status = 'Accept Friend Request';
                                }else if (checker ==1){
                                  status = 'You Are Friends';
                                }else if (checker ==2){
                                  status = 'Waiting For Approval';
                                }
                                return RaisedButton(
                                  onPressed: () async{
                                    if(checker ==0 ){
                                      await Firestore.instance
                                          .collection('Users')
                                          .document(Wrapper.UID)
                                          .collection('friends')
                                          .document(user.id)
                                          .updateData({'isFriend': 1});
                                      await Firestore.instance
                                          .collection('Users')
                                          .document(user.id)
                                          .collection('friends')
                                          .document(Wrapper.UID)
                                          .updateData({'isFriend': 1});
                                    }
                                  },
                                  color: Colors.white,
                                  textColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red,width: 2.0)),
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(status, style: TextStyle(fontSize: 18)),
                                );
                              }else{
                                return RaisedButton(
                                  onPressed: () async{
                                    if(user.id!=Wrapper.UID){
                                      await DatabaseService().sendFriendRequest(user.id);
                                    }
                                  },
                                  color: user.id==Wrapper.UID ?Colors.white:Colors.red,
                                  textColor:user.id==Wrapper.UID ?Colors.red: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red,width: 2.0)),
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(user.id==Wrapper.UID ? 'This Is You':'Add Friend',
                                      style: TextStyle(fontSize: 20)),
                                );
                              }
                            }else {
                              return Text('');
                            }

                          }
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
