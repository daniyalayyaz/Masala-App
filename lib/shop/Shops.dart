import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordertakingapp/Model/Area.dart';
import 'package:ordertakingapp/Model/shop.dart';
import 'package:ordertakingapp/Product/Product.dart';
import 'package:ordertakingapp/Provider/CartProvider.dart';
import 'package:ordertakingapp/Provider/ProductProvider.dart';
import 'package:ordertakingapp/Service/Database.dart';
import 'package:ordertakingapp/ServiceAdmin/orderService.dart';
import 'package:provider/provider.dart';

DatabaseService db = new DatabaseService();

class Shops extends StatefulWidget {
  Shops({required this.name});
  final String name;

  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  TextEditingController amount = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var title = Shop.fromSnapshot(tripSnapshot).title.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    var data = await db.shop.where('AreaName', isEqualTo: widget.name).get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  var searchKey = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff29F05),
        title: const Text(
          "Explore Shops",
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
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchKey = value;
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
                  _resultsList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                _resultsList[index]['title'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xfff29F05)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.directions,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        displayModalBottomSheet(context,
                                            _resultsList[index]['TotalBlance']);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xfff29F05)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.credit_score,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Provider.of<Productprovider>(context,
                                                listen: false)
                                            .selectuser(_resultsList[index].id);
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .gettotalbill(_resultsList[index]
                                                .id
                                                .toString());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Product(
                                                name: _resultsList[index]
                                                    ['title']),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xfff29F05)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.shopping_cart_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xfff29F05)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.add_location_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Flexible(
                                    //   child: Column(
                                    //     children: [
                                    //       Padding(
                                    //         padding:
                                    //             const EdgeInsets.only(right: 8.0),
                                    //         child: FittedBox(
                                    //           child: Text(
                                    //             "Blance:" +
                                    //                     _resultsList[index]
                                    //                             ['TotalBlance']
                                    //                         .toString() ??
                                    //                 '',
                                    //             textAlign: TextAlign.center,
                                    //             style: const TextStyle(
                                    //               fontSize: 12.0,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            ],
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

  // }
  void displayModalBottomSheet(context, number) {
    double bill = 0.00;
    setState(() {
      bill = double.parse(number);
    });
    double bills = 0.00;

    amount.addListener(() {
      double amountadd = double.parse(amount.text);
      setState(() {
        bill = bill - amountadd;
        print(bill);
      });
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0)),
        ),
        builder: (BuildContext bc) {
          return Container(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Remaining Amount: ' + bill.toString(),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: amount,
                      onChanged: (value) {},
                      style: TextStyle(
                          color: Color(0xff212121),
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xfff29F05), width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Enter Amount',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: ElevatedButton(
                        child: Text('Add Amount',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        onPressed: () {},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                  color: Color(0xfff29F05), width: 2.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xfff29F05)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 20))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: ElevatedButton(
                        child: Text('Deduct Amount',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xfff29F05))),
                        onPressed: () {},
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                  color: Color(0xfff29F05), width: 2.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 20))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
