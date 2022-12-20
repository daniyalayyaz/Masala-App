import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ordertakingapp/Area/Area.dart';
import 'package:ordertakingapp/Login.dart';
import 'package:ordertakingapp/Model/Area.dart';

class OrderDashboard extends StatefulWidget {
  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: new Drawer(
      //   child: ListView(
      //     children: [
      //       new Divider(
      //         color: Colors.orange,
      //         height: 5.0,
      //       ),
      //       new ListTile(
      //         title: Text("Home"),
      //         onTap: () {
      //           Navigator.of(context).pop();
      //           Navigator.pushReplacement(context,
      //               MaterialPageRoute(builder: (context) => OrderDashboard()));
      //         },
      //       ),
      //       new Divider(
      //         color: Colors.orange,
      //         height: 5.0,
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Color(0xfff29F05),
        title: const Text(
          "Dashboard",
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
          children: [
            // SizedBox(height: 100),
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              // child: Image(
              //   image: AssetImage('assets/logo-wide.png'),
              // ),
            ),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 8.0,
                  children: List.generate(choices.length, (index) {
                    return Center(
                      child: SelectCard(choice: choices[index]),
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'All Area', icon: FontAwesomeIcons.user),
  const Choice(title: 'All Order', icon: FontAwesomeIcons.cartPlus),
  const Choice(title: 'Reports', icon: FontAwesomeIcons.print),
  const Choice(title: 'Credit', icon: Icons.credit_card),
  const Choice(title: 'Logout', icon: Icons.logout),
];

class SelectCard extends StatelessWidget {
  const SelectCard({required this.choice});
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,
      onTap: () {
        if (choice.title == 'All Area') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Areas()));
        }
        if (choice.title == 'All Orders') {
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => GaragList()));
        }
        if (choice.title == 'Reports') {
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => StaffManager()));
        }
        if (choice.title == 'Credit') {
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => GarageSpport()));
        }
        if (choice.title == 'Logout') {
          _logout();

          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => GarageLogin()));
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => ManageCitation()));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 10,
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Icon(choice.icon,
                              size: 50.0, color: Color(0xfff29F05))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          choice.title,
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ]),
              ),
            )),
      ),
    );
  }

  _logout() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    // GoogleSignIn googleSignIn = new GoogleSignIn();
    // await googleSignIn.signOut();
  }
}
