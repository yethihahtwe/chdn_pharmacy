import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'edit_package_form.dart';

class ManagePackageForm extends StatefulWidget {
  const ManagePackageForm({super.key});

  @override
  State<ManagePackageForm> createState() => _ManagePackageFormState();
}

class _ManagePackageFormState extends State<ManagePackageForm> {
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
                                icon: Icon(Icons.edit))
                            : Text('')),
                      ]));
                    }
                    return DataTable(
                        columns: [
                          DataColumn(
                              label: Text(
                            'Package Form',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'Edit',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                        ],
                        headingRowColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 255, 227, 160),
                        ),
                        rows: rows);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                })
          ])),
    );
  }
}
