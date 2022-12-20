import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordertakingapp/Service/Database.dart';

class Productprovider with ChangeNotifier {
  DatabaseService db = DatabaseService();
  late BuildContext context;
  late String prodcuturl;
  late String number;
  late String addresss;
  late String nearlocation;
  late String user;
  late File _image;

  // var user = "eee";
  final picker = ImagePicker();
  String get getuser => user;
  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    } else {
      print('No image selected.');
      notifyListeners();
    }
    return _image;
  }

  selectuser(usersid) {
    user = usersid;
    print(user);
    notifyListeners();
  }

  alertDialog(context, titel, content) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: titel,
            content: content,
            actions: [
              CupertinoDialogAction(
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context);
                    },
                    child: Text("ok")),
              )
            ],
          );
        });
  }

  Future<String> imageupload(filepath) async {
    File file = File(filepath);
    var timestamp = DateTime.now().microsecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref("productimage/$timestamp").putFile(file);
    } on FirebaseException catch (e) {
      e.toString();
    }
    String downloadurl =
        await _storage.ref("productimage/$timestamp").getDownloadURL();
    this.prodcuturl = downloadurl;
    notifyListeners();
    return prodcuturl;
  }

  Future<bool> saveprodcut(prodcutname, des, price) async {
    var timestamp = DateTime.now().microsecondsSinceEpoch;
    try {
      CollectionReference _prodcuts =
          FirebaseFirestore.instance.collection('products');
      _prodcuts.doc(timestamp.toString()).set({
        'prodcuctname': prodcutname,
        'Qty': des,
        "productimage":
            "https://image.shutterstock.com/image-vector/no-image-available-sign-absence-260nw-373243873.jpg",
        // "Subcategory": dropdownsubvalue,
        "collectiontype": "Featured Product",
        "Price": price,
        "ProdcutId": timestamp.toString(),
        // "Colors":  p,
        // "Sizes":size,
      }).then((value) {
        return true;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveuser(name, email, password) async {
    var timestamp = DateTime.now().microsecondsSinceEpoch;
    try {
      CollectionReference _user = FirebaseFirestore.instance.collection('user');
      _user.doc(timestamp.toString()).set({
        'Name': name,
        'Email': email,
        "Password": password,
        // "Colors":  p,
        // "Sizes":size,
      }).then((value) {
        return true;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  saveArea(name) {
    var timestamp = DateTime.now().microsecondsSinceEpoch;
    try {
      CollectionReference _area = db.area;
      _area.doc(timestamp.toString()).set({
        'title': name,
        "imgUrl":
            "https://www.logolynx.com/images/logolynx/12/129bd9d828ff3ecebc4c5b681cd93802.jpeg",
        // "Colors":  p,
        // "Sizes":size,
      }).then((value) {
        return true;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveShop(name, area) async{
    int valu=0;
    print(name);
    print(area);
    var timestamp = DateTime.now().microsecondsSinceEpoch;
    try {
      CollectionReference _shop = db.shop;
      _shop.doc(timestamp.toString()).set({
        'title': name,
        'AreaName': area,
        "TotalBlance":valu,
        "imgUrl":
            'https://thumbs.dreamstime.com/b/vintage-general-store-enamel-tin-sign-retro-old-west-blue-rustic-embossed-isolated-shop-grunge-vintage-general-store-enamel-tin-128250267.jpg',
        // "Colors":  p,
        // "Sizes":size,
      }).then((value) {
        return true;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  saveuseraddress(address, number, nearlocation) async {
    try {
      // CollectionReference _prodcuts =await
      //     FirebaseFirestore.instance.collection('CustomerAddress');
      // _prodcuts.doc(user.uid).set({
      //   'Address': address,
      //   'Number': number,
      //   'nearlocation': nearlocation,

      statusChaage();
      // });
      this.number = number;
      notifyListeners();
      this.addresss = address;
      notifyListeners();
      this.nearlocation = nearlocation;
      notifyListeners();
    } catch (e) {}
    return null;
  }

  saveuseraddressprovider(address, number, nearlocation) async {
    try {
      this.number = number;
      notifyListeners();
      this.addresss = address;
      notifyListeners();
      this.nearlocation = nearlocation;
      notifyListeners();
    } catch (e) {}
    return null;
  }

  statusChaage() async {
    CollectionReference cart = FirebaseFirestore.instance.collection('cart');

    try {
      cart.doc(user).update({"status": "True"}).then((value) => cart
              .doc(user)
              .collection("Products")
              .get()
              .then((QuerySnapshot snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          }));
    } catch (e) {}
    return null;
  }
}
