
import 'dart:io';

import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class DatabaseService {
  final String uid,streamId,lastDoc;
  FirebaseStorage _storage = FirebaseStorage.instance;


  DatabaseService({this.uid,this.streamId,this.lastDoc});

  // Users collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  // User Friends
  final CollectionReference userFriendsCollection =
  Firestore.instance.collection('Users').document(Wrapper.UID).collection('friends');

  // Chat collection reference
  final CollectionReference chatCollection =
  Firestore.instance.collection('Chats');


  Future<void> updateUserData({User user}) async {
    return await userCollection.document(uid).setData({
      'password': user.password,
      'name': user.name,
      'id': uid,
      'phone': user.phone,
      'logo': user.logo,
    });
  }

  Future<void> uploadPic(String uid) async {
    //Get the file from the image picker and store it
    PickedFile  image = await ImagePicker().getImage(source: ImageSource.gallery);
    File file = File(image.path);

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("images/$uid");

    //Upload the file to firebase
    reference.putFile(file);

    // Waits till the file is uploaded then stores the download url
    String location = await reference.getDownloadURL() as String ;
    
    print(location);

    await Firestore.instance.collection('Users')
        .document(uid)
        .updateData({'logo': location});

    /*//returns the download url
    return location;*/
  }
  

  // stream for msg tab
  Stream<List<Friends>> get getLastChatUser {
    return userFriendsCollection.where('isFriend',isEqualTo: 1).orderBy('lastChat',descending: true).snapshots().map(Friends().fromQuery);
  }


  // Stream for request tab
  Stream<List<Friends>> get getFriendRequests {
    return userFriendsCollection.where('isFriend',isEqualTo: 0).snapshots().map(Friends().fromQuery);
  }

  // stream for online tab
  Stream<List<Friends>> get getCurrentFriends {
    return userFriendsCollection.where('isFriend',isEqualTo: 1).snapshots().map(Friends().fromQuery);
  }


  // stream for live chat
  Stream<List<Fluff>> get getLiveFluff {
    return chatCollection
        .document(streamId)
        .collection('chat').orderBy('time',descending: true).snapshots().map(Fluff().fromQuery);
  }

  // stream for LAST CHAT Room in message tab for each row
  Stream<DocumentSnapshot> get getLastChatRoom  {
    return chatCollection
        .document(streamId)
        .snapshots();
  }

  // stream for LAST CHAT Doc in message tab for each row
  Stream<DocumentSnapshot> get getLastChatDoc  {
    return chatCollection
        .document(streamId)
        .collection('chat')
        .document(lastDoc)
        .snapshots();
  }

  // query users stream
  Stream<List<User>>  getUsers(String pho) {
    return userCollection
        .where('phone',isEqualTo: pho)
        .snapshots()
        .map(_userListFromSnapshot);
  }



  //replace it later with fromJson in user Model class
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return User(
        id: doc.data['id'] ?? '',
          password: doc.data['password'] ?? '',
          name: doc.data['name'] ?? '',
          phone: doc.data['phone'] ?? '',
          logo: doc.data['logo'] ?? '',
      );
    }).toList();
  }

  Stream<DocumentSnapshot> get getUserById  {
    return userCollection
        .document(streamId)
        .snapshots();
  }


  //check if the user my friend or not
  Stream<DocumentSnapshot> get isFriend {
    return userCollection
        .document(Wrapper.UID)
        .collection('friends')
        .document(streamId)
        .snapshots();
  }

  //send Friend Request
  Future<void> sendFriendRequest(String id) async {
    try {
      final snapShot = await userCollection
          .document(Wrapper.UID)
          .collection('friends')
          .document(id)
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == docId doesn't exist.
       /* final newChatRoom = await chatCollection.add(new ChatRoom(id: chatCollection.id,userA: Wrapper.UID ,userB: id).toJson());*/

        final newChatRoom = chatCollection.document();

        await newChatRoom.setData(new ChatRoom(id: chatCollection.id,userA: Wrapper.UID ,userB: id).toJson()).then((doc) async{
          print('hop ${newChatRoom.documentID}');
          await postFriendRequestOnHisSide(roomId: newChatRoom.documentID,hisId: id);
          await postFriendRequestOnMySide(roomId: newChatRoom.documentID,hisId: id);

          return true;

        }).catchError((error) {
          print(error);
        });
      }

    } catch (error) {
      print(error.toString());
    }
  }

  //step 2 add the chat room ref on his document
  Future<void> postFriendRequestOnHisSide({String roomId,String hisId}) async {
    return await userCollection
        .document(hisId)
        .collection('friends')
        .document(Wrapper.UID)
        .setData(new Friends(hisId: Wrapper.UID,roomId: roomId ,isFavorite: false,isFriend: 0).toJson());
  }
  //step 3 add the chat room ref on my document
  Future<void> postFriendRequestOnMySide({String roomId,String hisId}) async {
    return await userCollection
        .document(Wrapper.UID)
        .collection('friends')
        .document(hisId)
        .setData(new Friends(hisId: hisId,roomId: roomId ,isFavorite: false,isFriend: 2).toJson());
  }


  //post fluff <Message>
  Future<void> postFluff({String roomId,Fluff fluff,String hisId}) async {

     final newFluff = chatCollection
         .document(roomId)
         .collection('chat')
         .document();

     await newFluff.setData(fluff.toJson()).then((doc) async{
       print('hop ${newFluff.documentID}');

       //update the chat room
       await chatCollection.document(roomId).updateData({'lastChat':newFluff.documentID });
       //update mySide
       await userCollection.document(Wrapper.UID).collection('friends').document(hisId).updateData({'lastChat':fluff.time });
       //update hisSide
       await userCollection.document(hisId).collection('friends').document(Wrapper.UID).updateData({'lastChat':fluff.time });


     }).catchError((error) {
       print(error);
     });





  }


/*


  // get Food Menu stream
  Stream<List<Category>> get getFoodMenu {
    return foodMenuCollection.snapshots().map(_foodMenuListFromSnapshot);
  }

  List<Category> _foodMenuListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Category(
        id: doc.data['id'] ?? '',
        count: doc.data['count'] ?? 0,
        image: doc.data['image'] ?? '0',
        order: doc.data['order'] ?? '0',
      );
    }).toList();
  }


  Stream<DocumentSnapshot> get getUserCart2  {
    return Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('User Extra')
        .document('Cart')
        .snapshots();
  }

  Future<String> addItemToUserCart({Cart cart}) async {
    String test = '0';
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('User Extra')
        .document('Cart').setData(cart.toJson()).whenComplete(() => test = 'complete');
    return test;
  }


  Future<String> addItem({FoodDisplay food}) async {
    String test = '0';
    await Firestore.instance
        .collection('Food')
        .document('Sandwiches')
        .collection('items')
        .document().setData(food.toJson()).whenComplete(() => test = 'complete');
    return test;
  }






*/








}
