import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference area = FirebaseFirestore.instance.collection('Area');
  CollectionReference shop = FirebaseFirestore.instance.collection('shop');

  CollectionReference product =
      FirebaseFirestore.instance.collection('product');
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  CollectionReference loan = FirebaseFirestore.instance.collection('loan');
}
