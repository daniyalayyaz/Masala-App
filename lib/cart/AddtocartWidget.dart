import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ordertakingapp/Provider/CartProvider.dart';
import 'package:ordertakingapp/Provider/ProductProvider.dart';
import 'package:ordertakingapp/Service/Cartservice.dart';
import 'package:ordertakingapp/cart/CartScreen.dart';
import 'package:provider/provider.dart';

class AddtocardWidget extends StatefulWidget {
  final DocumentSnapshot document;

  AddtocardWidget({required this.document});
  @override
  _AddtocardWidgetState createState() => _AddtocardWidgetState();
}

class _AddtocardWidgetState extends State<AddtocardWidget> {
  Cartservice _cartservice = new Cartservice();
  var user;
  Future<String> getid() async {
    user = Provider.of<Productprovider>(context, listen: false).getuser;

    return "done";
  }

  bool status = true;
  bool exit = false;
  @override
  void initState() {
    getid();
    getdata();
    getCartData();

    super.initState();
  }

  getdata() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user)
        .collection('products')
        .where('ProdcutId',
            isEqualTo: (widget.document.data() as Map)['ProdcutId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["ProdcutId"]);
        if (doc["ProdcutId"] == (widget.document.data() as Map)['ProdcutId']) {
          setState(() {
            exit = true;
          });
        }
      });
    });
  }

  getCartData() async {
    final snapshot =
        await _cartservice.cart.doc(user).collection('products').get();
    if (snapshot.docs.length == 0) {
      setState(() {
        status = false;
      });
    } else {
      setState(() {
        status = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _carprovider = Provider.of<CartProvider>(context);
    return status
        ? Center(
            child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue)),
          )
        : exit
            ? Counterwidget(
                document: widget.document,
              )
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Add to Cart',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  onPressed: () {
                    EasyLoading.show(status: 'Adding To Cart');
                    _cartservice.addtocart(widget.document, user).then((value) {
                      getdata();
                      _carprovider.gettotalbill(user);
                      EasyLoading.showSuccess('Added To Cart');
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(color: Color(0xfff29F05), width: 2.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xfff29F05)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 20))),
                ),
              );
  }
}
