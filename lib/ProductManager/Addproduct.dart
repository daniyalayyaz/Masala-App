import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordertakingapp/Provider/ProductProvider.dart';
import 'package:ordertakingapp/ServiceAdmin/orderService.dart';
import 'package:provider/provider.dart';

class AddProdcut extends StatefulWidget {
  static String routeName = "/AddProdcut";
  @override
  _AddProdcutState createState() => _AddProdcutState();
}

class _AddProdcutState extends State<AddProdcut> {
  final formKey = GlobalKey<FormState>();
  OrderService orderService = new OrderService();

  var temparray = [];

  var dropdownvalueservice;
  var temparraysize = [];

  late File _image;
  late String areaname;
  late String shopname;
  bool _load = false;
  var dropdownvalue;
  late String dropdownsubvalue;
  late String _category;

  // getCheckboxItems() {
  //   colors.forEach((key, value) {
  //     if (value == true) {
  //       temparray.add(key);
  //     }
  //   });
  //   temparray.forEach((element) {
  //     print(element);
  //   });
  // }

  // List<String> subchildcategory=["Bamboo Access","Silk Access"];
  late String prodcutname;
  late int price;
  late String productdes;
  TextEditingController category = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Productprovider>(context,listen: false);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
          isScrollable: true,
          labelColor: Colors.red,
          indicatorWeight: 10,
          tabs: [
            Tab(
              child: const Text("Add Product"),
            ),
            const Tab(child: Text("Add User")),
            const Tab(child: Text("Add Area")),
            const Tab(child: Text("Add Shops")),
          ],
        )),
        body: TabBarView(
          children: [
            ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Product name";
                          }
                          setState(() {
                            prodcutname = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Product name",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Divider(),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Product Price";
                          }
                          setState(() {
                            price = int.parse(value);
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Product Price",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Divider(),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Qty";
                          }
                          setState(() {
                            productdes = value!;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Product Qty",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Divider(),
                      // Column(children: [
                      //   new StreamBuilder<QuerySnapshot>(
                      //       stream: FirebaseFirestore.instance
                      //           .collection('Category')
                      //           .snapshots(),
                      //       builder: (context, snapshot) {
                      //         if (!snapshot.hasData)
                      //           return const Center(
                      //             child: const CupertinoActivityIndicator(),
                      //           );
                      //         var length = snapshot.data!.docs.length;

                      //         return new Container(
                      //           padding: EdgeInsets.only(bottom: 16.0),
                      //           child: new Row(
                      //             children: <Widget>[
                      //               new Expanded(
                      //                   flex: 2,
                      //                   child: new Container(
                      //                     padding: EdgeInsets.fromLTRB(
                      //                         12.0, 10.0, 10.0, 10.0),
                      //                     child: new Text("Category"),
                      //                   )),
                      //               new Expanded(
                      //                 flex: 4,
                      //                 child: new InputDecorator(
                      //                   decoration: const InputDecoration(
                      //                     //labelText: 'Activity',
                      //                     hintText: 'Choose an category',
                      //                     hintStyle: TextStyle(
                      //                       fontSize: 16.0,
                      //                       fontFamily: "OpenSans",
                      //                       fontWeight: FontWeight.normal,
                      //                     ),
                      //                   ),
                      //                   child: new DropdownButton(
                      //                     value: dropdownvalue,
                      //                     hint: Text("select Category"),
                      //                     isDense: true,
                      //                     onChanged: (newValue) async {
                      //                       setState(() {
                      //                         dropdownvalue =
                      //                             newValue.toString();
                      //                         print(newValue);
                      //                       });
                      //                     },
                      //                     items: snapshot.data!.docs
                      //                         .map((DocumentSnapshot document) {
                      //                       print(document["Name"]);
                      //                       return new DropdownMenuItem(
                      //                           value: document["Name"],
                      //                           child: new Container(
                      //                             decoration: new BoxDecoration(
                      //                                 borderRadius:
                      //                                     new BorderRadius
                      //                                         .circular(5.0)),

                      //                             //color: primaryColor,
                      //                             child: new Text(
                      //                                 document["Name"]),
                      //                           ));
                      //                     }).toList(),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       })
                      // ]),
                      // Text("Select Size"),
                      // Column(
                      //   children: sizes.keys.map((String keys) {
                      //     return new CheckboxListTile(
                      //       title: new Text(keys),
                      //       value: sizes[keys],
                      //       activeColor: Colors.pink,
                      //       checkColor: Colors.white,
                      //       onChanged: (values) async {
                      //         setState(() {
                      //           sizes[keys] = values!;
                      //           if (values) {
                      //             temparraysize.add(keys);
                      //           } else {
                      //             temparraysize.remove(keys);
                      //           }
                      //         });
                      //       },
                      //     );
                      //   }).toList(),
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     provider.getImage().then((value) {
                      //       setState(() {
                      //         _load = true;
                      //         _image = value;
                      //       });
                      //     });
                      //   },
                      //   child: SizedBox(
                      //     width: 150,
                      //     height: 150,
                      //     child: Card(
                      //       child: Center(
                      //         child: _load == true
                      //             ? Image.file(_image)
                      //             : Text("Select Image"),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      Divider(),

                      FlatButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              EasyLoading.show(status: 'loading...');
                              EasyLoading.dismiss();
                        
                                EasyLoading.show(status: "Processing Save");
                             
                                 
                                    provider
                                        .saveprodcut(
                                      prodcutname,
                                      productdes,
                                      price,
                                    )
                                        .then((value) {
                                      if (value) {
                                        EasyLoading.showSuccess(
                                            "Product Save Successfully");

                                        formKey.currentState!.reset();
                                        setState(() {
                                          _load = false;
                                        });
                                      } else {
                                        EasyLoading.showError("Fail");
                                      }
                                    });
                                  } else {
                                    provider.alertDialog(
                                        context,
                                        "Image  upload",
                                        "Fail to upload image");
                                  

                              
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save"))
                    ],
                  ),
                ),
              ),
            ]),
            ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Name";
                          }
                          setState(() {
                            prodcutname = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Enter name",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Divider(),
                      TextFormField(
                        maxLength: 5,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter email ";
                          }
                          setState(() {
                            price = int.parse(value);
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: " Email",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Divider(),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter password ";
                          }
                          setState(() {
                            productdes = value!;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: " password",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),

                      // Text("Select Size"),
                      // Column(
                      //   children: sizes.keys.map((String keys) {
                      //     return new CheckboxListTile(
                      //       title: new Text(keys),
                      //       value: sizes[keys],
                      //       activeColor: Colors.pink,
                      //       checkColor: Colors.white,
                      //       onChanged: (values) async {
                      //         setState(() {
                      //           sizes[keys] = values!;
                      //           if (values) {
                      //             temparraysize.add(keys);
                      //           } else {
                      //             temparraysize.remove(keys);
                      //           }
                      //         });
                      //       },
                      //     );
                      //   }).toList(),
                      // ),

                      Divider(),

                      FlatButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              EasyLoading.show(status: 'loading...');
                              EasyLoading.dismiss();

                              EasyLoading.show(status: "Processing Save");

                              provider
                                  .saveuser(
                                prodcutname,
                                price,
                                productdes,
                              )
                                  .then((value) {
                                if (value) {
                                  EasyLoading.showSuccess(
                                      "User Save Successfully");

                                  formKey.currentState!.reset();
                                } else {
                                  EasyLoading.showError("Fail");
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save"))
                    ],
                  ),
                ),
              ),
            ]),
            // AddService(),
            // TodoList(),

            ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Area Name";
                          }
                          setState(() {
                            areaname = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Enter Area Name",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Divider(),

                      // Text("Select Size"),
                      // Column(
                      //   children: sizes.keys.map((String keys) {
                      //     return new CheckboxListTile(
                      //       title: new Text(keys),
                      //       value: sizes[keys],
                      //       activeColor: Colors.pink,
                      //       checkColor: Colors.white,
                      //       onChanged: (values) async {
                      //         setState(() {
                      //           sizes[keys] = values!;
                      //           if (values) {
                      //             temparraysize.add(keys);
                      //           } else {
                      //             temparraysize.remove(keys);
                      //           }
                      //         });
                      //       },
                      //     );
                      //   }).toList(),
                      // ),

                      Divider(),

                      FlatButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              EasyLoading.show(status: 'loading...');
                              EasyLoading.dismiss();

                              EasyLoading.show(status: "Processing Save");

                              provider
                                  .saveArea(
                                areaname,
                              )
                                  .then((value) {
                                if (value) {
                                  EasyLoading.showSuccess(
                                      "User Save Successfully");

                                  formKey.currentState!.reset();
                                } else {
                                  EasyLoading.showError("Fail");
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save"))
                    ],
                  ),
                ),
              ),
            ]),

            ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Shop Name";
                          }
                          setState(() {
                            shopname = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Enter Shop Name",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Divider(),

                      Column(children: [
                        new StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Area')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: const CupertinoActivityIndicator(),
                                );
                              var length = snapshot.data!.docs.length;

                              return new Container(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                        flex: 2,
                                        child: new Container(
                                          padding: EdgeInsets.fromLTRB(
                                              12.0, 10.0, 10.0, 10.0),
                                          child: new Text("Area"),
                                        )),
                                    new Expanded(
                                      flex: 4,
                                      child: new InputDecorator(
                                        decoration: const InputDecoration(
                                          //labelText: 'Activity',
                                          hintText: 'Choose an Area',
                                          hintStyle: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        child: new DropdownButton(
                                          value: dropdownvalue,
                                          hint: Text("select Area"),
                                          isDense: true,
                                          onChanged: (newValue) async {
                                            setState(() {
                                              dropdownvalue =
                                                  newValue.toString();
                                              print(newValue);
                                            });
                                          },
                                          items: snapshot.data!.docs
                                              .map((DocumentSnapshot document) {
                                           
                                            return new DropdownMenuItem(
                                                value: document["title"],
                                                child: new Container(
                                                  decoration: new BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0)),

                                                  //color: primaryColor,
                                                  child: new Text(
                                                      document["title"]),
                                                ));
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                      ]),

                      // Text("Select Size"),
                      // Column(
                      //   children: sizes.keys.map((String keys) {
                      //     return new CheckboxListTile(
                      //       title: new Text(keys),
                      //       value: sizes[keys],
                      //       activeColor: Colors.pink,
                      //       checkColor: Colors.white,
                      //       onChanged: (values) async {
                      //         setState(() {
                      //           sizes[keys] = values!;
                      //           if (values) {
                      //             temparraysize.add(keys);
                      //           } else {
                      //             temparraysize.remove(keys);
                      //           }
                      //         });
                      //       },
                      //     );
                      //   }).toList(),
                      // ),

                      Divider(),

                      FlatButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // EasyLoading.show(status: 'loading...');
                              // // EasyLoading.dismiss();

                              EasyLoading.show(status: "Processing Save");

                              provider
                                  .saveShop(
                                shopname,
                                dropdownvalue,
                              )
                                  .then((value) {
                                if (value) {
                                  print(value);
                                  EasyLoading.showSuccess(
                                      "Shop Save Successfully");

                                  formKey.currentState!.reset();
                                } else {
                                  EasyLoading.showError("Fail");
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save"))
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
