import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordertakingapp/Service/Cartservice.dart';



class CartProvider with ChangeNotifier {
  double total = 0.0;
  
  int qty = 1;

  late QuerySnapshot snapshot;
  var  cartqty;
  List cartlist = [];
  Cartservice _cartservices = new Cartservice();
  Future<double?> gettotalbill(user) async {
    List _newlist = [];
    var cartotal = 0.0;
    QuerySnapshot querySnapshot = await _cartservices.cart
        .doc(user)
        .collection("products")
        .get();
        
    if (querySnapshot == null) {
      return null;
    } else {
      querySnapshot.docs.forEach((element) {
        if (!_newlist.contains(element.data())) {
          _newlist.add(element.data());
          this.cartlist = _newlist;
          notifyListeners();
        }
        cartotal += (element.data() as Map)["ProductPrice"] * (element.data()as Map)["qty"];
      });
      this.total = cartotal;

      notifyListeners();
      this.cartqty = querySnapshot.size;
      notifyListeners();
      this.snapshot = querySnapshot;
      notifyListeners();
      return cartotal;
    }
  }

  Future<void> quantityupdate(docid, qty,user) {
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user)
        .collection('products')
        .doc(docid);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Prodcut Not Exist Cart");
          }

          // Update the follower count based on the current count
          // Note: this could be done without a transaction
          // by updating the population using FieldValue.increment()

          // Perform an update on the document
          transaction.update(documentReference, {'qty': qty});
          gettotalbill(user);

          // Return the new count
          return qty;
        })
        .then((value) => print("updated quantity $value"))
        .catchError((error) => print("Failed to update quantity: $error"));
  }

  Future<void> delete(docid,user) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user)
        .collection('products')
        .doc(docid)
        .delete();
  }
}
