import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  
  late final String title;
  late final String imgUrl;

  Area(
    this.title,
    this.imgUrl,
  );
  Area.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        imgUrl = snapshot['imgUrl'];
}
