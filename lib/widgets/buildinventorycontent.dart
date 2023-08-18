import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/item_inventory.dart';
import 'package:flutter/material.dart';

class BuildInventoryContent extends StatefulWidget {
  const BuildInventoryContent({super.key});

  @override
  State<BuildInventoryContent> createState() => _BuildInventoryContentState();
}

class _BuildInventoryContentState extends State<BuildInventoryContent> {
  // sort column
  int sortColumnIndex = 0;
  bool sortAscending = true;
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
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getAllBalance(),
        builder: (context, snapshot) {
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
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemInventory(
                                  itemId: item['stock_item_id'],
                                  itemName: item['item_name'] ?? '',
                                  itemType: item['item_type'] ?? '')));
                      setState(() {});
                    },
                    icon: const Icon(Icons.play_circle_filled,
                        color: Color.fromARGB(255, 218, 0, 76), size: 16)))
              ]));
            } // filter rows based in search input
            final List<DataRow> filteredRows = rows.where(
              (row) {
                final itemName = row.cells[0].child.toString();
                final itemType = row.cells[1].child.toString();
                final searchQuery = _searchController.text.toLowerCase();
                return itemName.toLowerCase().contains(searchQuery) ||
                    itemType.toLowerCase().contains(searchQuery);
              },
            ).toList();
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
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                        label: const Text(
                          'Item',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        label: const Text(
                          'Type',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    DataColumn(
                        numeric: true,
                        label: const Text(
                          'Balance',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onSort: (columnIndex, ascending) {
                          _sortColumn(columnIndex, ascending);
                        }),
                    const DataColumn(
                        label: Text(
                      '',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
}
