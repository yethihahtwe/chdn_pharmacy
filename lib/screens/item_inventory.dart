import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

import 'stock_detail.dart';

class ItemInventory extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String itemType;

  const ItemInventory(
      {super.key,
      required this.itemId,
      required this.itemName,
      required this.itemType});

  @override
  State<ItemInventory> createState() => _ItemInventoryState();
}

class _ItemInventoryState extends State<ItemInventory> {
  int? totalBalance;

  int sortColumnIndex = 0;
  bool sortAscending = true;
  void sortColumn(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  void initState() {
    DatabaseHelper().getTotalBalance(widget.itemId).then((value) {
      setState(() {
        totalBalance = value!['total_balance'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('${widget.itemName}, ${widget.itemType}'),
          centerTitle: true,
        ), // end of app bar
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // start of total balance card
              Card(
                elevation: 5,
                child: ListTile(
                  leading: const Icon(Icons.medication),
                  title: Text(widget.itemName),
                  subtitle: Text(widget.itemType),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'စုစုပေါင်းအရေအတွက်',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(totalBalance.toString(),
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ), // end of total balance card
              const SizedBox(height: 10),
              // start of balance by batch table
              const Text('Batch အလိုက်အရေအတွက်'),
              balanceByBatchTable(),
              // end of balance by batch table
              const Divider(),
              // start of stock by item table
              const Text('အဝင်အထွက်မှတ်တမ်းများ'),
              stockByItemTable(),
              // end of stock by item table
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child:
                    reusableHotButton(Icons.chevron_left_outlined, 'Back', () {
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }

  Widget balanceByBatchTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getBalanceByBatch(widget.itemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              final List<DataRow> rows = [];
              for (final item in snapshot.data!) {
                rows.add(DataRow(cells: [
                  DataCell(Text(
                      '${item['stock_exp_date']}' == ''
                          ? 'N/A'
                          : '${item['stock_exp_date']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text(
                      '${item['stock_batch']}' == ''
                          ? ' N/A'
                          : ' ${item['stock_batch']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text('${item['source_place']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text('${item['donor']}',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text('${item['balance_by_batch']}' ' ',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(Text('${item['package_form']}' '(s)',
                      style: const TextStyle(fontSize: 10))),
                  DataCell(IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                        Icons.outbound_outlined,
                        color: Colors.red,
                        size: 16,
                      ))),
                ]));
              } // sort the rows based on selected column
              rows.sort((a, b) {
                final aValue = a.cells[sortColumnIndex].child.toString();
                final bValue = b.cells[sortColumnIndex].child.toString();
                return sortAscending
                    ? aValue.compareTo(bValue)
                    : bValue.compareTo(aValue);
              });
              return DataTable(
                  columnSpacing: 0.1,
                  columns: [
                    DataColumn(
                        label: const Text('Exp',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Batch',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Source',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Donor',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        numeric: true,
                        label: const Icon(
                          Icons.tag,
                          size: 12,
                        ),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Pkg',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumn(columnIndex, ascending);
                        }),
                    const DataColumn(
                        label: Text('ထုတ်',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)))
                  ],
                  sortAscending: sortAscending,
                  sortColumnIndex: sortColumnIndex,
                  headingRowColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 227, 160)),
                  rows: rows);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Text('There is no data with the item specified.');
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget stockByItemTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getAllStockByItem(widget.itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            final List<DataRow> rows = [];
            for (final item in snapshot.data!) {
              rows.add(DataRow(cells: [
                DataCell(Text(
                  '${item['stock_date']}',
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
                            : item['item_type'] == 'DMG'
                                ? const Icon(Icons.flash_on,
                                    size: 16, color: Colors.red)
                                : const Text('')),
                DataCell(Text(
                  '${item['source_place']}',
                  style: const TextStyle(fontSize: 10),
                )),
                DataCell(Text(
                  '${item['donor']}',
                  style: const TextStyle(fontSize: 10),
                )),
                DataCell(Text(
                    '${item['stock_exp_date']}' == ''
                        ? 'N/A'
                        : '${item['stock_exp_date']}',
                    style: const TextStyle(fontSize: 10))),
                DataCell(Text(
                  '${item['stock_amount']}',
                  style: const TextStyle(fontSize: 10),
                )),
                DataCell(Text(
                  ' ${item['package_form']}' '(s)',
                  style: const TextStyle(fontSize: 10),
                )),
                DataCell(IconButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StockDetail(
                                    stockId: item['stock_id'],
                                    itemName: widget.itemName,
                                    itemType: widget.itemType,
                                    packageForm: item['package_form'],
                                  )));
                      if (result == 'success') {
                        setState(() {});
                      } else {
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.play_circle_filled,
                        color: Color.fromARGB(255, 218, 0, 76), size: 16)))
              ]));
            }
            return DataTable(
                columnSpacing: 1,
                columns: const [
                  DataColumn(
                      label: Text(
                    'Date',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Icon(
                    Icons.sync_alt_outlined,
                    size: 16,
                  )),
                  DataColumn(
                      label: Text(
                    'Source',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    'Donor',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    'Exp',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      numeric: true,
                      label: Icon(
                        Icons.tag,
                        size: 16,
                      )),
                  DataColumn(
                      label: Text(
                    'Pkg',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    '',
                  )),
                ],
                headingRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 227, 160)),
                rows: rows);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Text('There is no data with the stock.');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
