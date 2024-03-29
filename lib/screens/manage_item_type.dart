import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/edit_item_type.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

import 'add_item_type.dart';

class ManageItemType extends StatefulWidget {
  const ManageItemType({super.key});

  @override
  State<ManageItemType> createState() => _ManageItemTypeState();
}

class _ManageItemTypeState extends State<ManageItemType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of add item type fab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddItemType()));
          if (result == 'success') {
            setState(() {});
          }
        },
        label: const Text(
          'Add Item Type',
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
      // start of app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Manage Item Types'),
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
            reusableForeignKeyConstraintMessage('ပစ္စည်းအမျိုးအစား', context),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getAllItemType(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DataRow> rows = [];
                    for (final item in snapshot.data!) {
                      rows.add(DataRow(cells: [
                        DataCell(Text('${item['item_type_name']}')),
                        DataCell(item['item_type_editable'] == 'true'
                            ? IconButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditItemType(
                                              itemTypeName:
                                                  '${item['item_type_name']}',
                                              itemTypeId:
                                                  item['item_type_id'])));
                                  if (result == 'success') {
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 218, 0, 76),
                                ))
                            : const Text('')),
                      ]));
                    }
                    return Column(
                      children: [
                        DataTable(
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Item Type',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text('Edit',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                            ],
                            headingRowColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 255, 227, 160),
                            ),
                            rows: rows),
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
    );
  }
}
