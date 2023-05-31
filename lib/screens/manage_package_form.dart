import 'package:chdn_pharmacy/screens/add_package_form.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'edit_package_form.dart';

class ManagePackageForm extends StatefulWidget {
  const ManagePackageForm({super.key});

  @override
  State<ManagePackageForm> createState() => _ManagePackageFormState();
}

class _ManagePackageFormState extends State<ManagePackageForm> {
  // current sorted column
  int _sortColumnIndex = 0;

  // default sort
  bool _sortAscending = true;

  // sort function
  void _sortColumn(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Manage Package Forms'),
        centerTitle: true,
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
            reusableForeignKeyConstraintMessage('ထုပ်ပိုးပုံစံ', context),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getAllPackageForm(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DataRow> rows = [];
                    for (final item in snapshot.data!) {
                      rows.add(DataRow(cells: [
                        DataCell(Text('${item['package_form_name']}')),
                        DataCell(item['package_form_editable'] == 'true'
                            ? IconButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPackageForm(
                                              packageFormName:
                                                  '${item['package_form_name']}',
                                              packageFormId:
                                                  item['package_form_id'])));
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
                    // sort the rows based on selected column
                    rows.sort((a, b) {
                      final aValue = a.cells[_sortColumnIndex].child.toString();
                      final bValue = b.cells[_sortColumnIndex].child.toString();
                      return _sortAscending
                          ? aValue.compareTo(bValue)
                          : bValue.compareTo(aValue);
                    });
                    return Column(
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(
                                label: const Text(
                                  'Package Form',
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
                          rows: rows,
                          sortAscending: _sortAscending,
                          sortColumnIndex: _sortColumnIndex,
                        ),
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
                }),
            const SizedBox(
              height: 80,
            )
          ])),
      // start of add package form fab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPackageForm()));
          if (result == 'success') {
            setState(() {});
          }
        },
        label: const Text(
          'Add Package Form',
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
