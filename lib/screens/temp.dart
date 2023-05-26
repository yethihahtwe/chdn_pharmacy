import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:flutter/material.dart';

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

  List<DataRow> rows = [];
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
    super.initState();
    DatabaseHelper().getTotalBalance(widget.itemId).then((value) {
      setState(() {
        totalBalance = value!['total_balance'];
      });
    });

    DatabaseHelper().getBalanceByBatch(widget.itemId).then((value) {
      setState(() {
        rows = value.map((item) {
          return DataRow(cells: [
            DataCell(Text(item['stock_exp_date'])),
            DataCell(Text(item['stock_batch'])),
            DataCell(Text(item['source_place'])),
            DataCell(Text(item['donor'])),
            DataCell(Text(item['balance_by_batch'])),
            DataCell(Text(item['package_form'])),
            DataCell(IconButton(
                onPressed: () {}, icon: const Icon(Icons.outbound_outlined)))
          ]);
        }).toList();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
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
            balanceByBatchTable()
            // end of balance by batch table
          ])),
    );
  }

  Widget balanceByBatchTable() {
    rows.sort((a, b) {
      final aValue = a.cells[sortColumnIndex].child.toString();
      final bValue = b.cells[sortColumnIndex].child.toString();
      return sortAscending
          ? aValue.toString().compareTo(bValue.toString())
          : bValue.toString().compareTo(aValue.toString());
    });
    return DataTable(
        columnSpacing: 0.1,
        columns: [
          DataColumn(
              label: const Icon(
                Icons.event_busy_outlined,
                size: 12,
              ),
              onSort: (columnIndex, ascending) {
                sortColumn(columnIndex, ascending);
              }),
          DataColumn(
              label: const Icon(
                Icons.confirmation_number_outlined,
                size: 12,
              ),
              onSort: (columnIndex, ascending) {
                sortColumn(columnIndex, ascending);
              }),
          DataColumn(
              label: const Icon(
                Icons.business_outlined,
                size: 12,
              ),
              onSort: (columnIndex, ascending) {
                sortColumn(columnIndex, ascending);
              }),
          DataColumn(
              label: const Icon(
                Icons.groups_outlined,
                size: 12,
              ),
              onSort: (columnIndex, ascending) {
                sortColumn(columnIndex, ascending);
              }),
          DataColumn(
              label: const Icon(
                Icons.tag,
                size: 12,
              ),
              onSort: (columnIndex, ascending) {
                sortColumn(columnIndex, ascending);
              }),
          DataColumn(
              label: const Icon(
                Icons.inventory_2_outlined,
                size: 12,
              ),
              onSort: (columnIndex, ascending) {
                sortColumn(columnIndex, ascending);
              }),
        ],
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
        headingRowColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 255, 227, 160)),
        rows: rows);
  }
}
