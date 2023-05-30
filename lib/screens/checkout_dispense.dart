import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../database/database_helper.dart';
import 'reusable_widget.dart';

class CheckoutDispense extends StatefulWidget {
  final String stockDate;
  final int destinationId;
  const CheckoutDispense(
      {super.key, required this.stockDate, required this.destinationId});

  @override
  State<CheckoutDispense> createState() => _CheckoutDispenseState();
}

class _CheckoutDispenseState extends State<CheckoutDispense> {
  // to display destination name
  String? destinationName;

  // to display stock date
  String? dateText;

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
    setState(() {
      dateText = widget.stockDate;
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [buildConfirmButton(), sizedBoxW10(), buildCancelButton()],
      ),
    );
  }

  Widget buildDestinationNameText() {
    return Text(
      '${widget.stockDate} တွင် $destinationName သို့ထုတ်ပေးမည့်ပစ္စည်းများ',
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
              DataCell(IconButton(
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
                                    Navigator.pop(context);
                                    Navigator.pop(context, 'success');
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
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
              )),
            ]));
          }
          return DataTable(
              columnSpacing: 0.1,
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

  Widget buildConfirmButton() {
    return FloatingActionButton.extended(
      heroTag: 'btnConfirm',
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('Confirm?'),
                  content: const Text(
                    'Are sure you want to confirm the dispense?\nထုတ်ယူမည့်ပစ္စည်းစာရင်းအတည်ပြုရန်သေချာပါသလား',
                    style: TextStyle(fontSize: 12),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async {
                          await DatabaseHelper()
                              .confirmCheckout(dateText!, widget.destinationId);
                          EasyLoading.showSuccess(
                              'ပစ္စည်းထုတ်ယူစာရင်းထည့်သွင်းပြီးပါပြီ။');
                          Navigator.pop(context);
                          Navigator.pop(context, 'success');
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
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
      label: const Text(
        'Confirm',
        style: TextStyle(
            color: Color.fromARGB(255, 49, 49, 49),
            fontWeight: FontWeight.bold),
      ),
      icon: const Icon(
        Icons.launch_outlined,
        color: Color.fromARGB(255, 49, 49, 49),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 197, 63),
    );
  }

  Widget buildCancelButton() {
    return FloatingActionButton.extended(
      heroTag: 'btnBack',
      onPressed: () {
        Navigator.pop(context);
      },
      label: const Text(
        'Go Back',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      icon: const Icon(Icons.keyboard_backspace_outlined, color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 218, 0, 76),
    );
  }
}
