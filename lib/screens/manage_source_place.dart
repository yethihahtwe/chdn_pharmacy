import 'package:chdn_pharmacy/screens/add_source_place.dart';
import 'package:chdn_pharmacy/screens/edit_source_place.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class ManageSourcePlace extends StatefulWidget {
  const ManageSourcePlace({super.key});

  @override
  State<ManageSourcePlace> createState() => _ManageSourcePlaceState();
}

class _ManageSourcePlaceState extends State<ManageSourcePlace> {
  // sort column index
  int sortColumnIndex = 0;

  // default sort
  bool sortAscending = true;

  // sort function
  void _sortColumn(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of add source place fab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddSourcePlace()));
          if (result == 'success') {
            setState(() {});
          }
        },
        label: const Text(
          'Add Source Place',
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Manage Source Places'),
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
            FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getAllSourcePlace(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    final List<DataRow> rows = [];
                    for (final item in snapshot.data!) {
                      rows.add(DataRow(cells: [
                        DataCell(Text('${item['source_place_name']}')),
                        DataCell(item['source_place_editable'] == 'true'
                            ? IconButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditSourcePlace(
                                              sourcePlaceName:
                                                  '${item['source_place_name']}',
                                              sourcePlaceId:
                                                  item['source_place_id'])));
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
                    } // sort the rows based on selected column
                    rows.sort((a, b) {
                      final aValue = a.cells[sortColumnIndex].child.toString();
                      final bValue = b.cells[sortColumnIndex].child.toString();
                      return sortAscending
                          ? aValue.compareTo(bValue)
                          : bValue.compareTo(aValue);
                    });
                    return DataTable(
                        columns: [
                          DataColumn(
                              label: const Text(
                                'Source Place',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, ascending) {
                                _sortColumn(columnIndex, ascending);
                              }),
                          DataColumn(
                              label: const Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, ascending) {
                                _sortColumn(columnIndex, ascending);
                              }),
                        ],
                        headingRowColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 227, 160),
                        ),
                        sortAscending: sortAscending,
                        sortColumnIndex: sortColumnIndex,
                        rows: rows);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Text('No Source places');
                  }
                }),
            const SizedBox(
              height: 80,
            )
          ])),
    );
  }
}
