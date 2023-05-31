import 'package:chdn_pharmacy/screens/add_donor.dart';
import 'package:chdn_pharmacy/screens/edit_donor.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class ManageDonor extends StatefulWidget {
  const ManageDonor({super.key});

  @override
  State<ManageDonor> createState() => _ManageDonorState();
}

class _ManageDonorState extends State<ManageDonor> {
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
        title: const Text('Manage Donors'),
        centerTitle: true,
      ), // end of app bar
      // start of add donor fab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddDonor()));
          if (result == 'success') {
            setState(() {});
          }
        },
        label: const Text(
          'Add Donor',
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
            reusableForeignKeyConstraintMessage('အလှူရှင်အမည်', context),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getAllDonor(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      final List<DataRow> rows = [];
                      for (final item in snapshot.data!) {
                        rows.add(DataRow(cells: [
                          DataCell(Text('${item['donor_name']}')),
                          DataCell(item['donor_editable'] == 'true'
                              ? IconButton(
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditDonor(
                                                donorName:
                                                    '${item['donor_name']}',
                                                donorId: item['donor_id'])));
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
                                  'Donor',
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
                          'There is no data with the Donors. Please add by pressing `Add Donor` button.\nအလှူရှင်အဖွဲ့အစည်းများအတွက် အချက်အလက်များမရှိသေးပါ။ `Add Donor` ခလုတ်ကိုနှိပ်၍ဖြည့်သွင်းပါ');
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
