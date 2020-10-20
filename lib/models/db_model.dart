import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id, password, name, phone, logo;
  bool status;

  User({this.id, this.password, this.name, this.phone, this.logo, this.status});

  User.fromSnapShot(DocumentSnapshot doc) : id = doc.data['id'],
        password = doc.data['password'],
        name = doc.data['name'],
        phone = doc.data['phone'],
        status = doc.data['status'],
        logo = doc.data['logo'];


  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        name = json['name'],
        phone = json['phone'],
        status = json['status'],
        logo = json['logo'];
}

class Friends {
  String hisId, roomId;
  int isFriend;
  DateTime lastChat;
  bool isFavorite;

  Friends(
      {this.hisId, this.roomId, this.isFriend, this.lastChat, this.isFavorite});

  Friends.fromJson(Map<String, dynamic> json)
      : hisId = json['hisId'],
        roomId = json['roomId'],
        isFriend = json['isFriend'],
        lastChat = json['lastChat'].toDate(),
        isFavorite = json['isFavorite'];

  //replace it later with fromJson in user Model class
  List<Friends> fromQuery(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Friends(
        hisId: doc.data['hisId'] ?? '',
        roomId: doc.data['roomId'] ?? '',
        isFriend: doc.data['isFriend'] ?? '',
        lastChat: doc.data['lastChat']!=null?doc.data['lastChat'].toDate() : DateTime.now(),
        isFavorite: doc.data['isFavorite'] ?? '',
      );
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "hisId": hisId,
      "roomId": roomId,
      "isFriend": isFriend,
      "isFavorite": isFavorite,
    };
  }
}

class ChatRoom {
  String id, userA, userB;
  String lastChat;

  ChatRoom({this.id, this.userA, this.userB, this.lastChat});

  ChatRoom.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userA = json['userA'],
        userB = json['userB'],
        lastChat = json['lastChat'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userA": userA,
      "userB": userB,
      "lastChat": lastChat,
    };
  }
}

class Fluff {
  final String sender;
  final DateTime
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Fluff({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });

  List<Fluff> fromQuery(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Fluff(
        sender: doc.data['sender'] ?? '',
        time: doc.data['time'].toDate() ?? '',
        text: doc.data['text'] ?? '',
        isLiked: doc.data['isLiked'] ?? '',
        unread: doc.data['unread'] ?? '',
      );
    }).toList();
  }
  Fluff.fromJson(Map<String, dynamic> json)
      : sender = json['sender'],
        time = json['time'].toDate(),
        text = json['text'],
        isLiked = json['isLiked'],
        unread = json['unread'];

  Map<String, dynamic> toJson() {
    return {
      'sender' : sender,
      'time' : time,
      'text' : text,
      'isLiked' : isLiked,
      'unread' : unread,
    };
  }
}

/*class Message {
  final User sender;
  final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender
    ,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}*/
class FoodDisplay {
  String id,
      title,
      details,
      smallPrice,
      mediumPrice,
      largePrice,
      ratePercent,
      rateCount,
      img;

  FoodDisplay(
      {this.id,
      this.title,
      this.details,
      this.smallPrice,
      this.mediumPrice,
      this.largePrice,
      this.ratePercent,
      this.rateCount,
      this.img});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'smallPrice': smallPrice,
      'mediumPrice': mediumPrice,
      'largePrice': largePrice,
      'ratePercent': ratePercent,
      'rateCount': rateCount,
      'img': img,
    };
  }
}
