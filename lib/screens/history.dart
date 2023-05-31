import 'package:chdn_pharmacy/screens/stock_detail.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../database/shared_pref_helper.dart';
import '../widgets/nav_bar.dart';
import 'add_stock.dart';
import 'update_profile.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // Index for bottom navigation bar
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // sort column
  int sortColumnIndex = 0;
  bool sortAscending = false;
  void _sortColumn(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  // search
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  // clear search text field function
  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('History'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ), // end of app bar
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<String?>(
                // check profile set up
                future: SharedPrefHelper.getUserId(), //check user id
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    // return check inventory if user id present
                    return buildInventoryContent();
                  } else {
                    // return this if user id absent
                    return buildProfileSetup();
                  }
                })
          ])),
      // start of add stock fab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddStock()));
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
      ), // end of add stock fab
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }

  Widget buildInventoryContent() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getAllStock(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            final List<DataRow> rows = [];
            for (final item in snapshot.data!) {
              rows.add(DataRow(cells: [
                DataCell(Text(
                  item['stock_date'] == ''
                      ? 'Pending'
                      : '${item['stock_date']}',
                  style: const TextStyle(fontSize: 10),
                )),
                DataCell(item['stock_type'] == 'IN'
                    ? const Icon(
                        Icons.keyboard_arrow_right,
                        size: 16,
                        color: Colors.blueAccent,
                      )
                    : item['stock_type'] == 'OUT'
                        ? const Icon(Icons.keyboard_arrow_left,
                            size: 16, color: Colors.red)
                        : item['stock_type'] == 'EXP'
                            ? const Icon(Icons.warning,
                                size: 16, color: Colors.red)
                            : item['stock_type'] == 'DMG'
                                ? const Icon(Icons.bolt,
                                    size: 16, color: Colors.red)
                                : const Text('')),
                DataCell(Text('${item['item_name']}',
                    style: const TextStyle(fontSize: 10))),
                DataCell(Text('${item['item_type']}',
                    style: const TextStyle(fontSize: 10))),
                DataCell(Text('${item['stock_amount']}' ' ',
                    style: const TextStyle(fontSize: 10))),
                DataCell(Text('${item['stock_package_form']}' '(s)',
                    style: const TextStyle(fontSize: 10))),
                DataCell(item['stock_date'] != ''
                    ? IconButton(
                        onPressed: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockDetail(
                                        stockId: item['stock_id'],
                                        itemName: item['item_name'] ?? '',
                                        itemType: item['item_type'] ?? '',
                                        packageForm: item['stock_package_form'],
                                      )));
                          if (result == 'success') {
                            setState(() {});
                          } else {
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.play_circle_filled,
                            color: Color.fromARGB(255, 218, 0, 76), size: 16))
                    : const Text(''))
              ]));
            } // filter rows based in search input
            final List<DataRow> filteredRows = rows.where((row) {
              final itemName = row.cells[2].child.toString();
              final itemType = row.cells[3].child.toString();
              final searchQuery = _searchController.text.toLowerCase();
              return itemName.toLowerCase().contains(searchQuery) ||
                  itemType.toLowerCase().contains(searchQuery);
            }).toList();
            // sort the rows based on selected column
            filteredRows.sort((a, b) {
              final aValue = a.cells[sortColumnIndex].child.toString();
              final bValue = b.cells[sortColumnIndex].child.toString();
              return sortAscending
                  ? aValue.compareTo(bValue)
                  : bValue.compareTo(aValue);
            });
            return Column(children: [
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? null // not shown if search is empty
                          : IconButton(
                              onPressed: _clearSearch,
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              )),
                      hintText: 'Search Item',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DataTable(
                  columnSpacing: 0.1,
                  columns: [
                    DataColumn(
                        label: const Icon(
                          Icons.calendar_month,
                          size: 16,
                        ),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Icon(Icons.sync_alt, size: 16),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Icon(Icons.vaccines, size: 16),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Icon(Icons.category, size: 16),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        numeric: true,
                        label: const Icon(Icons.tag, size: 16),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Icon(Icons.inventory_2, size: 14),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    const DataColumn(
                        label: Text(
                      '',
                      style:
                          TextStyle(fontSize: 1, fontWeight: FontWeight.bold),
                    )),
                  ],
                  sortAscending: sortAscending,
                  sortColumnIndex: sortColumnIndex,
                  headingRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 227, 160),
                  ),
                  rows: filteredRows),
              const SizedBox(
                height: 50,
              )
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  'There is no inventory data. Please add by pressing `Add Stock` button.\nပစ္စည်းစာရင်းအချက်အလက်များမရှိသေးပါ။ `Add Stock` ခလုတ်ကိုနှိပ်၍ဖြည့်သွင်းပါ'),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget buildProfileSetup() {
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
              color: const Color.fromARGB(255, 218, 218, 218), width: 1),
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
}
