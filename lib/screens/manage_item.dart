import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/add_item.dart';
import 'package:chdn_pharmacy/screens/edit_item.dart';
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
  TextEditingController _searchController = TextEditingController();

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
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ))
                            : Text('')),
                      ]));
                    }
                    // sort the rows based on selected column
                    rows.sort((a, b) {
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
                                contentPadding: EdgeInsets.all(10),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                hintText: 'Search Item, ရှာရန်',
                                border: OutlineInputBorder(),
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
                        SizedBox(
                          height: 10,
                        ),
                        DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                    'Item\nName',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    _sortColumn(columnIndex, ascending);
                                  }),
                              DataColumn(
                                  label: Text(
                                    'Type',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    _sortColumn(columnIndex, ascending);
                                  }),
                              DataColumn(
                                label: Text(
                                  '',
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
                              Color.fromARGB(255, 255, 227, 160),
                            ),
                            sortAscending: sortAscending,
                            sortColumnIndex: sortColumnIndex,
                            rows: rows),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
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
        icon: Icon(
          Icons.add,
          color: Color.fromARGB(255, 49, 49, 49),
        ),
        backgroundColor: Color.fromARGB(255, 255, 197, 63),
      ),
    );
  }
}
