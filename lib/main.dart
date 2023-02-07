import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:ordertakingapp/Login.dart';

import 'package:ordertakingapp/Provider/CartProvider.dart';

import 'package:provider/provider.dart';

import 'Provider/ProductProvider.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Productprovider()),
        ChangeNotifierProvider(create: (_) => CartProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Masala App',
        theme: ThemeData(fontFamily: 'Urbanist', primarySwatch: Colors.amber),
        builder: EasyLoading.init(),
        home: Login(),
      ),
    );
  }
}
