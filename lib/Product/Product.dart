import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ordertakingapp/Area/Area.dart';
import 'package:ordertakingapp/Product/Bottomsheet.dart';
import 'package:ordertakingapp/Provider/CartProvider.dart';
import 'package:ordertakingapp/Provider/ProductProvider.dart';
import 'package:ordertakingapp/Service/Database.dart';
import 'package:ordertakingapp/ServiceAdmin/orderService.dart';
import 'package:provider/provider.dart';

class Product extends StatefulWidget {
  Product({required this.name});
  final String name;

  // ProductCardssubcategory({required this.name});
  // final String name;
  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  DatabaseService db = new DatabaseService();
  OrderService order = OrderService();
  var user;
  Future<String> getid() async {
    user = Provider.of<Productprovider>(context, listen: false).getuser;

    print(user);
    return "done";
  }

  @override
  void initState() {
    getid();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _carprovider = Provider.of<CartProvider>(context, listen: true);

    Widget addbutton(document) {
      return FlatButton(
        onPressed: () {
          // Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => ProductDetails(
          //                       document: document,
          //                     )));
        },
        child: Text("View Details"),
        color: Colors.blue,
      );
    }

    CollectionReference prodcuts =
        FirebaseFirestore.instance.collection("product");

    Widget categoryall({@required name, @required image}) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: 150,
            width: 100,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),
              SizedBox(height: 5),
              Center(
                  child: Text(
                name,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ))
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff29F05),
        title: Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          ElevatedButton(
            child: Text('Confirm Order',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            onPressed: () {
              EasyLoading.show(status: "Order Processing");
              saveordrt(context);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xfff25c05)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 20))),
          ),
        ],
      ),
      bottomSheet: _carprovider.cartqty != 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Products Quantity: ${_carprovider.cartqty}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Total Amount: Rs ${_carprovider.total} '),
                ),
                Expanded(
                    child: Container(
                        height: 50,
                        child: InkWell(
                          onTap: () {},
                        ))),
              ],
            )
          : Row(
              children: [
                // Text('Qnt:${_carprovider.cartqty } | ${_carprovider.total} '),
                Expanded(
                    child: Container(
                  height: 50,
                )),
              ],
            ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            // .where('Subcategory', isEqualTo: name)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.length == 0) {
            return Center(child: Text("No Product Available "));
          }

          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/Background.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
            )),
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 90, top: 30, left: 12, right: 12),
              child: Material(
                color: Colors.white,
                shadowColor: Color(0xffBDBDBD),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return new ListTile(
                        onTap: () {},
                        leading: SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              (document.data() as Map)['productimage'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          (document.data() as Map)['prodcuctname'],
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle:
                            Text('Rs ${(document.data() as Map)['Price']}'),
                        trailing: Bottomsheetcontainer(
                          document: document,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  saveordrt(context) {
    order.saveorder({
      'ShopName': widget.name,
      'pickstatus': 'false',
      'dilveredstatus': 'false',
      'Userid': Provider.of<Productprovider>(context, listen: false).getuser,
      "totalbill": Provider.of<CartProvider>(context, listen: false).total,
      'Products': Provider.of<CartProvider>(context, listen: false).cartlist,
      'Paymentstatus': 'COD',
      "Address": "demo address",
      "Number": "sjdjjdjdjd",
      "NearLocation": "ssssss",
    });
    statusChaage(context).then((value) {
      if (value) {
        EasyLoading.showSuccess("order Save");
      } else {
        EasyLoading.showError("order Not Save Please Check Your Connection");
      }
      {}
    });
  }
}

Future<bool> statusChaage(context) async {
  var userid = Provider.of<Productprovider>(context, listen: false).getuser;
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');

  try {
    cart.doc(userid).update({"status": "True"}).then((value) => cart
            .doc(userid)
            .collection("products")
            .get()
            .then((QuerySnapshot snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
          var total = Provider.of<CartProvider>(context, listen: false).total;
          db.shop.doc(userid).update({"TotalBlance": total.toString()});
          cart.doc(userid).update({"status": "True"});
          Provider.of<CartProvider>(context, listen: false)
              .gettotalbill(userid);
        }));

    return true;
  } catch (e) {}
  return false;
}
