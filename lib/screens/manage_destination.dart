import 'package:chdn_pharmacy/screens/add_destination.dart';
import 'package:chdn_pharmacy/screens/edit_destination.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class ManageDestination extends StatefulWidget {
  const ManageDestination({super.key});

  @override
  State<ManageDestination> createState() => _ManageDestinationState();
}

class _ManageDestinationState extends State<ManageDestination> {
  // sort column
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Manage Destinations'),
        centerTitle: true,
      ), // end of app bar
      // start of add destination fab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddDestination()));
          if (result == 'success') {
            setState(() {});
          }
        },
        label: const Text(
          'Add Destination',
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
                future: DatabaseHelper().getAllDestination(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      final List<DataRow> rows = [];
                      for (final item in snapshot.data!) {
                        rows.add(DataRow(cells: [
                          DataCell(Text('${item['destination_name']}')),
                          DataCell(item['destination_editable'] == 'true'
                              ? IconButton(
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditDestination(
                                                destinationName:
                                                    '${item['destination_name']}',
                                                destinationId:
                                                    item['destination_id'])));
                                    if (result == 'success') {
                                      setState(() {});
                                    }
                                  },
                                  icon:
                                      const Icon(Icons.edit, color: Colors.red))
                              : const Text('')),
                        ]));
                      }
                      // sort the rows based on selected column
                      rows.sort((a, b) {
                        final aValue =
                            a.cells[sortColumnIndex].child.toString();
                        final bValue =
                            b.cells[sortColumnIndex].child.toString();
                        return sortAscending
                            ? aValue.compareTo(bValue)
                            : bValue.compareTo(aValue);
                      });
                      return DataTable(
                          columns: [
                            DataColumn(
                                label: const Text(
                                  'Destination',
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
                      return const Text(
                          'There is no data with the Destinations. Please add by pressing `Add Destination` button.\nပေးပို့ရာနေရာများအတွက် အချက်အလက်များမရှိသေးပါ။ `Add Destination` ခလုတ်ကိုနှိပ်၍ဖြည့်သွင်းပါ');
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            const SizedBox(
              height: 80,
            )
          ])),
    );
  }
}
