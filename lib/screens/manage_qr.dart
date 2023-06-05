import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

import 'generated_qr.dart';

class ManageQr extends StatefulWidget {
  const ManageQr({super.key});

  @override
  State<ManageQr> createState() => _ManageQrState();
}

class _ManageQrState extends State<ManageQr> {
  // to sort columns
  int sortColumnIndex = 0; // default sorted column is stock date
  bool sortAscending = false; // default sort order is descending

  // search controller
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Generate QR'),
        centerTitle: true,
      ),
      body: Form(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBoxH20(),
                  buildInfoText(),
                  buildDispenseTable()
                ])),
      ),
    );
  }

  Widget buildDispenseTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getAllDispensed(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          final List<DataRow> rows = [];
          for (final item in snapshot.data!) {
            rows.add(DataRow(cells: [
              DataCell(Text('${item['stock_date']}')),
              DataCell(Text('${item['destination']}')),
              DataCell(IconButton(
                  icon: const Icon(
                    Icons.qr_code_2,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GeneratedQR(
                                  destinationId: item['stock_to'],
                                  destinationName: item['destination'],
                                  stockDate: item['stock_date'],
                                  enableGoBack: true,
                                )));
                  }))
            ]));
          } // sort the rows based on selected column

          // filter rows based in search input
          final List<DataRow> filteredRows = rows.where(
            (row) {
              final itemName = row.cells[0].child.toString();
              final itemType = row.cells[1].child.toString();
              final searchQuery = searchController.text.toLowerCase();
              return itemName.toLowerCase().contains(searchQuery) ||
                  itemType.toLowerCase().contains(searchQuery);
            },
          ).toList();
          filteredRows.sort((a, b) {
            final aValue = a.cells[sortColumnIndex].child.toString();
            final bValue = b.cells[sortColumnIndex].child.toString();
            return sortAscending
                ? aValue.compareTo(bValue)
                : bValue.compareTo(aValue);
          });
          return Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: searchController.text.isEmpty
                        ? null // not shown if search is empty
                        : IconButton(
                            onPressed: clearSearch,
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            )),
                    hintText: 'Search date and destination',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.background,
                            width: 2))),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              sizedBoxH10(),
              DataTable(
                  columns: [
                    DataColumn(
                        label: const Text('Date\ny-m-d',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Destination',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    const DataColumn(
                        label: Text('QR',
                            style: TextStyle(fontWeight: FontWeight.bold)))
                  ],
                  sortAscending: sortAscending,
                  sortColumnIndex: sortColumnIndex,
                  headingRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 227, 160),
                  ),
                  rows: filteredRows),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const Text(
              'There is no dispensed item yet. Please dispense items to generate QR.\nထုတ်ပေးသည့်ပစ္စည်းစာရင်းမရှိသေးပါ။ QR ရယူရန် ပစ္စည်းထုတ်ယူစာရင်း အရင်ထည့်သွင်းပါ။');
        }
      },
    );
  }

  void sortColumn(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  void clearSearch() {
    searchController.clear();
    setState(() {});
  }

  Widget buildInfoText() {
    return const Text(
        'ဤစာမျက်နှာတွင် ပစ္စည်းထုတ်ယူမှတ်တမ်းများကို ရက်စွဲနှင့် ပေးပို့ရာနေရာအလိုက် ဖော်ပြထားပါသည်',
        style: TextStyle(fontSize: 10));
  }
}
