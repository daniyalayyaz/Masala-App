import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordertakingapp/cart/AddtocartWidget.dart';


class Bottomsheetcontainer extends StatefulWidget {
  final DocumentSnapshot document;

  
  Bottomsheetcontainer({required this.document});
  @override
  _BottomsheetcontainerState createState() => _BottomsheetcontainerState();
}

class _BottomsheetcontainerState extends State<Bottomsheetcontainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Container(
          height: 30,
          width: 150,
          child: AddtocardWidget(
              document: widget.document),
        )
      ],
    );
  }
}
