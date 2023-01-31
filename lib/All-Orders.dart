import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({Key? key}) : super(key: key);

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  var OrderData = [
    {
      'orderId': 1,
      'shopname': 'Aziz Store',
      'areaname': 'Johar town',
      'orders': [
        {'name': 'Dalda Oil', 'price': '200', 'quantity': '3'},
        {'name': 'Milkpak Cream', 'price': '120', 'quantity': '2'},
        {'name': 'Lifebouy Shampoo', 'price': '240', 'quantity': '1'},
        {'name': 'Lux Soap', 'price': '500', 'quantity': '4'},
      ]
    },
    {
      'orderId': 2,
      'shopname': 'Euro Store',
      'areaname': 'Faisal town',
      'orders': [
        {'name': 'Dalda Oil', 'price': '200', 'quantity': '3'},
        {'name': 'Milkpak Cream', 'price': '120', 'quantity': '2'},
        {'name': 'Lifebouy Shampoo', 'price': '240', 'quantity': '1'},
        {'name': 'Lux Soap', 'price': '500', 'quantity': '4'},
      ]
    },
    {
      'orderId': 3,
      'shopname': 'Bilal Store',
      'areaname': 'Model town',
      'orders': [
        {'name': 'Dalda Oil', 'price': '200', 'quantity': '3'},
        {'name': 'Milkpak Cream', 'price': '120', 'quantity': '2'},
        {'name': 'Lifebouy Shampoo', 'price': '240', 'quantity': '1'},
        {'name': 'Lux Soap', 'price': '500', 'quantity': '4'},
      ]
    }
  ];
  @override
  void initState() {
    print(OrderData);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff29F05),
        title: const Text(
          "All Orders",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/Background.jpg'),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.8), BlendMode.dstATop),
        )),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // controller: _searchController,
              onChanged: (value) {
                // setState(() {
                //   searchKey = value;
                // });
              },
              style: TextStyle(
                  color: Color(0xff212121), fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xfff29F05), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Search Your Order',
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
              child: Accordion(
            maxOpenSections: 1,
            headerBackgroundColorOpened: Colors.black54,
            // scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            headerPadding:
                const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: OrderData.map((idx) => AccordionSection(
                  isOpen: false,
                  leftIcon: const Icon(Icons.food_bank, color: Colors.white),
                  header: Text('Order Info', style: _headerStyle),
                  content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print((idx as Map)["orders"].length);
                          },
                          child: Text(
                            'Store Name: ' + idx['shopname'].toString(),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          'Area Name: ' + idx['areaname'].toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        DataTable(
                          sortAscending: true,
                          sortColumnIndex: 1,
                          dataRowHeight: 40,
                          showBottomBorder: false,
                          columns: [
                            DataColumn(
                                label: Text('Name', style: _contentStyleHeader),
                                numeric: true),
                            DataColumn(
                                label: Text('Quantity',
                                    style: _contentStyleHeader)),
                            DataColumn(
                                label:
                                    Text('Price', style: _contentStyleHeader),
                                numeric: true),
                          ],
                          rows: List.generate((idx as Map)["orders"].length,
                              (index) {
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                    (idx as Map)["orders"][index]["name"],
                                    style: _contentStyle,
                                    textAlign: TextAlign.right)),
                                DataCell(Text(
                                    (idx as Map)["orders"][index]["quantity"],
                                    style: _contentStyle)),
                                DataCell(Text(
                                    (idx as Map)["orders"][index]["price"],
                                    style: _contentStyle,
                                    textAlign: TextAlign.right))
                              ],
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Total: 2000 Rs',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                )).toList(),
          )),
        ]),
      ),
    );
  }
}
