import 'package:cloud_firestore/cloud_firestore.dart';

class Shop{
 late final String imgUrl;
  late final String title;
  late final String areaname;
  late final int Totalblance;
  Shop(this.title,this.imgUrl,this.areaname,this.Totalblance);
  Shop.fromSnapshot(DocumentSnapshot snapshot)
  :title=snapshot['title'],
  Totalblance=snapshot['TotalBlance'],
  imgUrl=snapshot['imgUrl'],
  areaname=snapshot['AreaName'];


}