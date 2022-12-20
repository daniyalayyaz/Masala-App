import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:ordertakingapp/Provider/CartProvider.dart';
import 'package:ordertakingapp/Provider/ProductProvider.dart';
import 'package:ordertakingapp/Service/Cartservice.dart';
import 'package:ordertakingapp/cart/AddtocartWidget.dart';
import 'package:provider/provider.dart';

class Counterwidget extends StatefulWidget {
  final DocumentSnapshot document;

  Counterwidget({required this.document});

  @override
  _CounterwidgetState createState() => _CounterwidgetState();
}

class _CounterwidgetState extends State<Counterwidget> {
  TextEditingController quantity = TextEditingController();
  var user;
  Future<String> getid() async {
    user = Provider.of<Productprovider>(context, listen: false).getuser;

    return "done";
  }

  CartProvider cartProvider = new CartProvider();
  Cartservice _cartservice = new Cartservice();
  late int qty;

  bool status = true;
  bool exit = false;
  bool update = false;
  late String docids;
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
            qty = doc["qty"];
            quantity.text = qty.toString();
            docids = doc.id;
            print(qty);
          });
        } else {
          exit = false;
        }
      });
    });
  }

  @override
  void initState() {
    getid().then((value) => getdata());

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _carprovider = Provider.of<CartProvider>(context);
    return exit
        ? TextFormField(
            controller: quantity,
            style: TextStyle(
                color: Color(0xff212121), fontWeight: FontWeight.w600),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xfff29F05), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color(0xff9E9E9E),
                    width: 2.0,
                  ),
                )),
            onChanged: (value) {
              setState(() {
                update = true;
              });
              if (value == 1) {
                cartProvider.delete(docids, user).then((value) {
                  int quan;
                  getdata();
                  setState(() {
                    _carprovider.gettotalbill(user);
                    update = false;
                    exit = false;
                  });
                });
              }
              if (int.parse(value) > 1) {
                setState(() {
                  qty--;
                  update = true;
                });

                cartProvider
                    .quantityupdate(docids, int.parse(value), user)
                    .then((value) {
                  setState(() {
                    _carprovider.gettotalbill(user);
                    update = false;
                  });
                });
              }
            },
          )
        // ? Container(
        //     height: 28,
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.pink),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Container(
        //           child: InkWell(
        //               onTap: () {
        //                 setState(() {
        //                   update = true;
        //                 });
        //                 if (qty == 1) {
        //                   cartProvider.delete(docids,user).then((value) {

        //                     getdata();
        //                     setState(() {
        //                       _carprovider.gettotalbill(user);
        //                       update = false;
        //                       exit = false;
        //                     });
        //                   });
        //                 }
        //                 if (qty > 1) {
        //                   setState(() {
        //                     qty--;
        //                     update = true;
        //                   });

        //                   cartProvider
        //                       .quantityupdate(docids, qty,user)
        //                       .then((value) {
        //                     setState(() {
        //                       _carprovider.gettotalbill(user);
        //                       update = false;
        //                     });
        //                   });
        //                 }
        //               },
        //               child: Icon(
        //                   qty == 1 ? Icons.delete_outlined : Icons.remove,
        //                   color: Colors.pink)),
        //         ),
        //         Container(
        //           color: Colors.pink,
        //           width: 30,
        //           height: double.infinity,
        //           child: FittedBox(
        //               child: update
        //                   ? CircularProgressIndicator(
        //                       valueColor: AlwaysStoppedAnimation(Colors.blue))
        //                   : Text(qty.toString())),
        //         ),
        //         Container(
        //           child: InkWell(
        //               onTap: () {
        //                 setState(() {
        //                   qty++;
        //                   update = true;
        //                 });
        //                 cartProvider
        //                     .quantityupdate(docids, qty,user)
        //                     .whenComplete(() {
        //                   setState(() {
        //                     _carprovider.gettotalbill(user);
        //                     update = false;
        //                   });
        //                 });
        //               },
        //               child: Icon(
        //                 Icons.add,
        //                 color: Colors.pink,
        //               )),
        //         ),
        //       ],
        //     ),
        //   )
        : AddtocardWidget(document: widget.document);
  }
}
