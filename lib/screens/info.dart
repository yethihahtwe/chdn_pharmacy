import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/item_inventory.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  // Index for bottom navigation bar
  int _selectedIndex = 4;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Information'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ), // end of app bar
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                  'Top 10 nearest expiry\nသက်တမ်းလွန်ရက်အနီးဆုံး ပစ္စည်း (၁၀) မျိုး',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              nearestExpiryTable(),
              const Divider(),
              sizedBoxH20(),
              // start of logo row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: // start of chdn logo
                        Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 218, 218, 218),
                              width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(94, 158, 158, 158),
                                blurRadius: 10.0,
                                offset: Offset(0.0, 5.0)),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/CHDN_LOGO.png'),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox(width: 10)),
                  // start of ehssg logo
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 218, 218, 218),
                              width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(94, 158, 158, 158),
                                blurRadius: 10.0,
                                offset: Offset(0.0, 5.0)),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Image.asset('assets/images/EHSSG_Logo2.png'),
                      ),
                    ),
                  )
                ],
              ), // end of logo row
              const SizedBox(height: 20),
              const Center(
                  child: Text(
                'CHDNventory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              const Center(child: Text('alpha')),
              const Text('Release history',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(
                'alpha - released on 30-MAY-2023',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(style: TextStyle(fontSize: 12), 'The'),
                    Text(
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        'CHDN Pharmacy Inventory Management Mobile Application'),
                    Text(style: TextStyle(fontSize: 12), 'was developed for'),
                    Text(
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        'Civil Health and Development Network - Karenni'),
                    Text(style: TextStyle(fontSize: 12), 'by'),
                    Text(
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        'Ethnic Health Systems Strengthening Group.'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                  style: TextStyle(fontSize: 12),
                  'အင်တာနက်ဆက်သွယ်မှုမရရှိသည့်နေရာများတွင် အချက်အလက်များမှတ်တမ်းတင်သိမ်းဆည်းနိုင်ရန် ရည်ရွယ်ပါသည်။ အသုံးပြုသည့်ဖုန်း/တက်ဘလက်အတွင်း၌သာ အချက်အလက်များသိမ်းဆည်းထားသောကြောင့် အပလီကေးရှင်းကိုမဖျက်ခင် (သို့) စက်ပစ္စည်းပျက်စီးခြင်းမဖြစ်ပေါ်ခင် မိခင်အဖွဲ့အစည်းထံသို့ အင်တာနက်ရချိန်၌ အချက်အလက်များပေးပို့ထားရန်လိုပါသည်။'),
              sizedBoxH20()
            ])),
      ),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }

  Widget nearestExpiryTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getTopTenNearestExpiry(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              final List<DataRow> rows = [];
              for (final item in snapshot.data!) {
                rows.add(DataRow(cells: [
                  DataCell(Text('${item['stock_exp_date']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text('${item['item_name']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text('${item['item_type']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text('${item['stock_amount']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(IconButton(
                      onPressed: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemInventory(
                                      itemName: '${item['item_name']}',
                                      itemType: '${item['item_type']}',
                                      itemId: item['stock_item_id'],
                                    )));
                        if (result == 'success') {
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.red))),
                ]));
              }
              return DataTable(
                  columnSpacing: 9,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Exp\ny-m-d',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Item',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Type',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(label: Icon(Icons.tag, size: 16), numeric: true),
                    DataColumn(
                        label: Text(
                      '',
                    )),
                  ],
                  headingRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 227, 160),
                  ),
                  rows: rows);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Text(
                  'There is no data with the nearest expiry. \nသက်တမ်းလွန်ရက်အနီးဆုံးပစ္စည်းများအတွက် အချက်အလက်များမရှိသေးပါ။');
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
