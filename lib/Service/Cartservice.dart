import 'package:cloud_firestore/cloud_firestore.dart';


class Cartservice {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');


  int qty = 1;

  Future<void> addtocart(document,user) {
    cart.doc(user).set({
      "status": "false",
      'UserID': user,
    });
    return cart.doc(user).collection('products').add({
      'Productname': document.data()['prodcuctname'],
      'ProductPrice': document.data()['Price'],
      'ProdcutId': document.data()['ProdcutId'],
      'qty': qty,
      'productimage': document.data()['productimage'],
    });
  }

  removecard(docid,user) {
    cart.doc(user).collection("products").doc(docid).delete();
  }
}
