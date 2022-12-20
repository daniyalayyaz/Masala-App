import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordertakingapp/Login.dart';
import 'package:ordertakingapp/Model/Area.dart';
import 'package:ordertakingapp/Product/Product.dart';
import 'package:ordertakingapp/Service/Database.dart';
import 'package:ordertakingapp/shop/Shops.dart';

DatabaseService db = DatabaseService();

class Areas extends StatefulWidget {
  const Areas({Key? key}) : super(key: key);

  @override
  _AreasState createState() => _AreasState();
}

class _AreasState extends State<Areas> {
  TextEditingController _searchController = TextEditingController();
  var searchKey;
  late Future resultsLoaded;
  List allresult = [];
  List findresult = [];
  @override
  void initState() {
    // TODO: implement initState
    _searchController.addListener(_areahsearch);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_areahsearch);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getallarea();
  }

  _areahsearch() {
    onsearchlist();
  }

  onsearchlist() {
    var showlist = [];
    if (_searchController.text != "") {
      for (var item in allresult) {
        var title = Area.fromSnapshot(item).title.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showlist.add(item);
        }
      }
    } else {
      showlist = List.from(allresult);
    }
    setState(() {
      findresult = showlist;
    });
  }

  getallarea() async {
    var data = await db.area.get();
    setState(() {
      allresult = data.docs;
    });

    onsearchlist();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff29F05),
        title: const Text(
          "Explore Areas",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              icon: Icon(Icons.logout_rounded))
        ],
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
                  hintText: 'Search Your Area',
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
                findresult.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 10,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Shops(name: findresult[index]['title']),
                            ),
                          ),
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 100.0,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/location-pin.webp',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                findresult[index]['title'] ?? '',
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
            )),
          ],
        ),
      ),
    );
  }
}
