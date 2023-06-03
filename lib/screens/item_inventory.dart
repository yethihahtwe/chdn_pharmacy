import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/batch_inventory.dart';
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
  // to display total balance
  int? totalBalance;

  // to sort balance table
  int sortColumnIndexBalanceTable = 0;
  bool sortAscendingBalanceTable = true;
  void sortColumnBalanceTable(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndexBalanceTable = columnIndex;
      sortAscendingBalanceTable = ascending;
    });
  }

  // to sort stock table
  int sortColumnIndexStockTable = 0;
  bool sortAscendingStockTable = false;
  void sortColumnStockTable(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndexStockTable = columnIndex;
      sortAscendingStockTable = ascending;
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getTotalBalance(widget.itemId).then((value) {
      setState(() {
        totalBalance = value!['total_balance'];
      });
    });
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
              const Text(
                'Batch အလိုက်အရေအတွက်',
                style: TextStyle(fontSize: 12),
              ),
              balanceByBatchTable(),
              // end of balance by batch table
              const Divider(),
              // start of stock by item table
              const Text(
                'အဝင်အထွက်မှတ်တမ်းများ',
                style: TextStyle(fontSize: 12),
              ),
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
                      onPressed: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BatchInventory(
                                    itemName: widget.itemName,
                                    itemType: widget.itemType,
                                    itemId: widget.itemId,
                                    batchAmount: item['balance_by_batch'],
                                    packageForm: item['package_form'],
                                    packageFormId:
                                        item['stock_package_form_id'],
                                    expDate: item['stock_exp_date'],
                                    batchNumber: item['stock_batch'],
                                    sourcePlace: item['source_place'],
                                    sourcePlaceId:
                                        item['stock_source_place_id'],
                                    donor: item['donor'],
                                    donorId: item['stock_donor_id'])));
                        if (result == 'success') {
                          setState(() {
                            DatabaseHelper()
                                .getTotalBalance(widget.itemId)
                                .then((value) {
                              setState(() {
                                totalBalance = value!['total_balance'];
                              });
                            });
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.outbound_outlined,
                        color: Colors.red,
                        size: 16,
                      ))),
                ]));
              } // sort the rows based on selected column
              rows.sort((a, b) {
                final aValue =
                    a.cells[sortColumnIndexBalanceTable].child.toString();
                final bValue =
                    b.cells[sortColumnIndexBalanceTable].child.toString();
                return sortAscendingBalanceTable
                    ? aValue.compareTo(bValue)
                    : bValue.compareTo(aValue);
              });
              return DataTable(
                  columnSpacing: 0,
                  columns: [
                    DataColumn(
                        label: const Text('Exp\ny-m-d',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumnBalanceTable(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Batch',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumnBalanceTable(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Source',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumnBalanceTable(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Donor',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumnBalanceTable(columnIndex, ascending);
                        }),
                    DataColumn(
                        numeric: true,
                        label: const Icon(
                          Icons.tag,
                          size: 12,
                        ),
                        onSort: (columnIndex, ascending) {
                          sortColumnBalanceTable(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text('Pkg',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          sortColumnBalanceTable(columnIndex, ascending);
                        }),
                    const DataColumn(
                        label: Text('ပျက်စီး',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)))
                  ],
                  sortAscending: sortAscendingBalanceTable,
                  sortColumnIndex: sortColumnIndexBalanceTable,
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
                  item['stock_date'] != ''
                      ? '${item['stock_date']}'
                      : 'Pending',
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
                DataCell(item['stock_date'] != ''
                    ? IconButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockDetail(
                                        stockId: item['stock_id'],
                                        itemName: widget.itemName,
                                        itemType: widget.itemType,
                                        packageForm: item['package_form'],
                                      )));

                          DatabaseHelper()
                              .getTotalBalance(widget.itemId)
                              .then((value) {
                            setState(() {
                              totalBalance = value!['total_balance'];
                            });
                          });
                        },
                        icon: const Icon(Icons.play_circle_filled,
                            color: Color.fromARGB(255, 218, 0, 76), size: 16))
                    : const Text(''))
              ]));
            } // sort the rows based on selected column
            rows.sort((a, b) {
              final aValue =
                  a.cells[sortColumnIndexStockTable].child.toString();
              final bValue =
                  b.cells[sortColumnIndexStockTable].child.toString();
              return sortAscendingStockTable
                  ? aValue.compareTo(bValue)
                  : bValue.compareTo(aValue);
            });
            return DataTable(
                columnSpacing: 0.1,
                columns: [
                  DataColumn(
                      label: const Text(
                        'Date\ny-m-d',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        sortColumnStockTable(columnIndex, ascending);
                      }),
                  const DataColumn(
                      label: Icon(
                    Icons.sync_alt_outlined,
                    size: 16,
                  )),
                  DataColumn(
                      label: const Text(
                        'Source',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        sortColumnStockTable(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: const Text(
                        'Donor',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        sortColumnStockTable(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: const Text(
                        'Exp\ny-m-d',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        sortColumnStockTable(columnIndex, ascending);
                      }),
                  DataColumn(
                      numeric: true,
                      label: const Icon(
                        Icons.tag,
                        size: 16,
                      ),
                      onSort: (columnIndex, ascending) {
                        sortColumnStockTable(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: const Text(
                        'Pkg',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        sortColumnStockTable(columnIndex, ascending);
                      }),
                  const DataColumn(
                      label: Text(
                    '',
                  )),
                ],
                sortAscending: sortAscendingStockTable,
                sortColumnIndex: sortColumnIndexStockTable,
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
