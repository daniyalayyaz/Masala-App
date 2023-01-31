// ignore: file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordertakingapp/All-Orders.dart';
import 'package:ordertakingapp/Model/Area.dart';
import 'package:ordertakingapp/Model/shop.dart';
import 'package:geocoding/geocoding.dart' as goc;
import 'package:ordertakingapp/Product/Product.dart';

import 'package:ordertakingapp/Provider/CartProvider.dart';
import 'package:ordertakingapp/Provider/ProductProvider.dart';
import 'package:ordertakingapp/Service/Database.dart';
import 'package:ordertakingapp/ServiceAdmin/orderService.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:geocoding/geocoding.dart';

class OrderShops extends StatefulWidget {
  @override
  _OrderShopsState createState() => _OrderShopsState();
}

class _OrderShopsState extends State<OrderShops> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff29F05),
        title: const Text(
          "Choose Shop",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/Background.jpg'),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.8), BlendMode.dstATop),
        )),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    // searchKey = value;
                  });
                },
                style: TextStyle(
                    color: Color(0xff212121), fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xfff29F05), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Search Your Shop',
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.search_rounded,
                        color: Color(0xff9E9E9E),
                      )),
                  hintStyle: TextStyle(color: Color(0xff9E9E9E)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xff9E9E9E),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView(
                scrollDirection: Axis.vertical,
                controller: ScrollController(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: List.generate(
                  2,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllOrders()));
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 10,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 70.0,
                                  width: double.infinity,
                                  child: Image.asset(
                                    'assets/images/Store.webp',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'Shop Name',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
