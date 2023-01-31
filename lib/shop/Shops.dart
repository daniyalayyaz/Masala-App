// ignore: file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

DatabaseService db = new DatabaseService();

class Shops extends StatefulWidget {
  Shops({required this.name});
  final String name;

  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  late double lat;
  late double longitude;
  double get latitude => lat;

  late int getc;
  late Position currentLocation;
  TextEditingController amount = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  String? _currentAddress;
  Position? _currentPosition;
  _getCurrentPosition() async {}

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
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

  void navigateTo(double lat, double lng) async {
    launchURL(lat, lng);
  }

  launchURL(double lat, double lng) async {
    double homeLat = lat;
    double homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${homeLat},${homeLng}";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
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
  // getlocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }
  Future<Position> locationget() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    return position;
  }

  @override
  void initState() {
    // currentlocation();
    // TODO: implement initState
    super.initState();
    // getlocation();
    _searchController.addListener(_onSearchChanged);
  }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           _currentPosition!.latitude, _currentPosition!.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _currentAddress =
  //           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

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
                                      onTap: () {
                                        navigateTo(_resultsList[index]['lat'],
                                            _resultsList[index]['lng']);
                                      },
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
                                      onTap: () {
                                        currentlocation(_resultsList[index].id);
                                      },
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

  Future<Position> getCurrentlocation() {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  currentlocation(String id) async {
    getCurrentlocation();
    var postiondate = await GeolocatorPlatform.instance.getCurrentPosition();
    final cord = goc.placemarkFromCoordinates(
        postiondate.latitude, postiondate.longitude);
    // print("dd $cord");
    // var address = await goc.local.findAddressesFromCoordinates(cord);
    // String mianaddrerss = address.first.addressLine;
    // lat = postiondate.latitude;
    // lng = postiondate.longitude;
    // finalAddress = mianaddrerss;
    print(postiondate.latitude);
    print(postiondate.longitude);
    setState(() {
      lat = postiondate.latitude;
      longitude = postiondate.longitude;
    });
    db.shop.doc(id).update({"lat": lat, "lng": longitude});
    // notifyListeners();
  }
}
