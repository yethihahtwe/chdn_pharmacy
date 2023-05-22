import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/screens/item_inventory.dart';
import 'package:chdn_pharmacy/screens/update_profile.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../widgets/nav_bar.dart';
import 'add_stock.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Index for bottom navigation bar
  int _selectedIndex = 0;
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
        title: const Text('CHDNventory'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ), // end of app bar
      body: FutureBuilder<String?>(
        future: SharedPrefHelper.getUserId(), //check user id
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            // return check inventory if user id present
            return Scaffold(
              body: FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseHelper().getAllBalance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.isNotEmpty) {
                        final List<DataRow> rows = [];
                        for (final item in snapshot.data!) {
                          rows.add(DataRow(cells: [
                            DataCell(Text('${item['item_name']}')),
                            DataCell(Text('${item['item_type']}')),
                            DataCell(Text('${item['stock_amount']}')),
                            DataCell(IconButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ItemInventory(
                                                itemId:
                                                    '${item['stock_item_id']}',
                                              )));
                                  if (result == 'success') {
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(Icons.play_circle_filled,
                                    color: Colors.red))),
                          ]));
                        }
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              DataTable(
                                  columnSpacing: 20,
                                  columns: const [
                                    DataColumn(
                                        label: Text(
                                      'Item',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Type',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataColumn(
                                        numeric: true,
                                        label: Text(
                                          'Balance',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    DataColumn(
                                        label: Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                  headingRowColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 255, 227, 160),
                                  ),
                                  rows: rows),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              'There is no inventory data. Please add by pressing `Add Stock` button.\nပစ္စည်းစာရင်းအချက်အလက်များမရှိသေးပါ။ `Add Stock` ခလုတ်ကိုနှိပ်၍ဖြည့်သွင်းပါ'),
                        );
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              // start of add stock fab
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStock()));
                  if (result == 'success') {
                    setState(() {});
                  }
                },
                label: const Text(
                  'Add Stock',
                  style: TextStyle(
                      color: Color.fromARGB(255, 49, 49, 49),
                      fontWeight: FontWeight.bold),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 49, 49, 49),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 197, 63),
              ),
            );
          } else {
            // return this if user id absent
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              margin: EdgeInsets.only(
                  top: 20,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 218, 218, 218),
                      width: 1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(94, 158, 158, 158),
                        blurRadius: 10.0,
                        offset: Offset(0.0, 1.0)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 150,
                    child: Center(
                      child: Image.asset('assets/images/CHDN_LOGO.png'),
                    ),
                  ),
                  const Text(
                      'You have not set your Warehouse/Clinic profile.\nPlease click `Update Profile` button.\nဆေးဂိုဒေါင်/ဆေးခန်းဆိုင်ရာ အချက်အလက်များ မဖြည့်သွင်းရသေးပါ။ `Update Profile` ခလုတ်ကိုနှိပ်၍ဖြည့်သွင်းပါ'),
                  // Start of update profile button
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UpdateProfile()));
                        if (result == 'success') {
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('Update Profile'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.background),
                          foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
