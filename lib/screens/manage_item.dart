import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/add_item.dart';
import 'package:chdn_pharmacy/screens/edit_item.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

class ManageItem extends StatefulWidget {
  const ManageItem({super.key});

  @override
  State<ManageItem> createState() => _ManageItemState();
}

class _ManageItemState extends State<ManageItem> {
  int sortColumnIndex = 0;
  bool sortAscending = true;

  // controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  // sort column function
  void _sortColumn(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  // clear search text field function
  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Manage Items'),
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
            reusableForeignKeyConstraintMessage('ပစ္စည်းအမည်', context),
            // check presence of data
            FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getAllItem(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DataRow> rows = [];
                    for (final item in snapshot.data!) {
                      rows.add(DataRow(cells: [
                        DataCell(Text('${item['item_name']}')),
                        DataCell(Text('${item['item_type']}')),
                        DataCell(item['item_editable'] == 'true'
                            ? IconButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditItem(
                                              itemName: '${item['item_name']}',
                                              itemType: '${item['item_type']}',
                                              itemId: item['item_id'])));
                                  if (result == 'success') {
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ))
                            : const Text('')),
                      ]));
                    }
                    // filter rows based in search input
                    final List<DataRow> filteredRows = rows.where(
                      (row) {
                        final itemName = row.cells[0].child.toString();
                        final itemType = row.cells[1].child.toString();
                        final searchQuery =
                            _searchController.text.toLowerCase();
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
                    return Column(
                      children: [
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        width: 2))),
                            maxLines: 1,
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
                                    'Item\nName',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    _sortColumn(columnIndex, ascending);
                                  }),
                              DataColumn(
                                  label: const Text(
                                    'Type',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    _sortColumn(columnIndex, ascending);
                                  }),
                              DataColumn(
                                label: const Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onSort: (columnIndex, ascending) {
                                  _sortColumn(columnIndex, ascending);
                                },
                              ),
                            ],
                            headingRowColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 255, 227, 160),
                            ),
                            sortAscending: sortAscending,
                            sortColumnIndex: sortColumnIndex,
                            rows: filteredRows),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ])),
      // end of body
      // start of add item fab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddItem()));
          if (result == 'success') {
            setState(() {});
          }
        },
        label: const Text(
          'Add Item',
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
  }
}
