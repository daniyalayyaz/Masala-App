import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService
{





  CollectionReference orders=FirebaseFirestore.instance.collection("orders");
  saveorder(Map<String,dynamic> data){
  orders.add(
      data,
    );
  }
  saveorderpaypal(Map<String,dynamic> data){
  orders.add(

      data,
    );
  }

  
}
