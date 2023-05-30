import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'reusable_widget.dart';

class CheckoutDispense extends StatefulWidget {
  final String date;
  final int destinationId;
  const CheckoutDispense(
      {super.key, required this.date, required this.destinationId});

  @override
  State<CheckoutDispense> createState() => _CheckoutDispenseState();
}

class _CheckoutDispenseState extends State<CheckoutDispense> {
  // to display destination name
  String? destinationName;

  @override
  void initState() {
    super.initState();
    DatabaseHelper()
        .getSingleValueReusable('tbl_destination', 'destination_name',
            'destination_id', widget.destinationId)
        .then((value) {
      setState(() {
        destinationName = value?['destination_name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Checkout Dispense'),
        centerTitle: true,
      ), // end of appbar
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sizedBoxH20(),
            buildDestinationNameText(),
            buildDraftDispenseTable(),
          ])),
    );
  }

  Widget buildDestinationNameText() {
    return Text(
      '${widget.date} တွင် $destinationName သို့ထုတ်ပေးမည့်ပစ္စည်းများ',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget buildDraftDispenseTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getDraftDispense(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          final List<DataRow> rows = [];
          for (final item in snapshot.data!) {
            rows.add(DataRow(cells: [
              DataCell(Text('${item['item_name']}',
                  style: const TextStyle(fontSize: 10))),
              DataCell(Text('${item['item_type']}',
                  style: const TextStyle(fontSize: 10))),
              DataCell(Text('${item['stock_amount']}',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold))),
              DataCell(Text('${item['package_form']}(s)',
                  style: const TextStyle(fontSize: 10))),
              DataCell(Text('${item['stock_exp_date']}',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold))),
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${item['source_place']}',
                      style: const TextStyle(fontSize: 10)),
                  const Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Text('${item['donor']}', style: const TextStyle(fontSize: 10))
                ],
              )),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Color.fromARGB(255, 218, 0, 76),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 16,
                      color: Color.fromARGB(255, 218, 0, 76),
                    ),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('Delete Draft?'),
                                content: const Text(
                                  'Are sure you want to delete the draft dispense?\nထုတ်ပေးမည့်စာရင်းမှဖယ်ရှားရန်သေချာပါသလား',
                                  style: TextStyle(fontSize: 12),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () async {
                                        await DatabaseHelper()
                                            .deleteStock(item['stock_id']);
                                        Navigator.pop(context, 'success');
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      )),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ]);
                          });
                      setState(() {});
                    },
                  )
                ],
              )),
            ]));
          }
          return DataTable(
              columnSpacing: 5,
              columns: const [
                DataColumn(
                    label: Text('Item',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10))),
                DataColumn(
                    label: Text('Type',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10))),
                DataColumn(
                    numeric: true,
                    label: Icon(
                      Icons.tag,
                      size: 16,
                    )),
                DataColumn(
                    label: Text('Pkg',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10))),
                DataColumn(
                    label: Text('Exp',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10))),
                DataColumn(
                    label: Text('Source',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10))),
                DataColumn(label: Text('')),
              ],
              headingRowColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 255, 227, 160),
              ),
              rows: rows);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
