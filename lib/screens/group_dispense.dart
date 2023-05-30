import 'package:chdn_pharmacy/screens/checkout_dispense.dart';
import 'package:chdn_pharmacy/screens/draft_dispense.dart';
import 'package:chdn_pharmacy/screens/reusable_function.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../database/database_helper.dart';
import '../model/data_model.dart';

class GroupDispense extends StatefulWidget {
  const GroupDispense({super.key});

  @override
  State<GroupDispense> createState() => _GroupDispenseState();
}

class _GroupDispenseState extends State<GroupDispense> {
  // to show notification icon
  int draftCount = 0;
  // date value to pick from date picker
  DateTime? date;
  // date text to display in date picker button
  String getDateText() {
    if (date == null) {
      return 'Select date';
    } else {
      String day = date!.day.toString().padLeft(2, '0');
      String month = date!.month.toString().padLeft(2, '0');
      String year = date!.year.toString();
      return '$year-$month-$day';
    }
  }

  // list to get destinations
  List<ReusableMenuModel> destinationList = [];
  // selected destination
  int? selectedDestination;

  // controller for search
  TextEditingController searchController = TextEditingController();
  // dispose
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  // clear search text field function
  void clearSearch() {
    searchController.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // get draft stock count
    DatabaseHelper().getCountDraftStock().then((value) {
      setState(() {
        draftCount = value;
      });
    });
    // get destination
    DatabaseHelper().getAllReusable('tbl_destination').then((value) {
      setState(() {
        destinationList = value
            .map((e) => ReusableMenuModel(
                e['destination_id'] as int, e['destination_name'].toString()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Dispense Items'),
        centerTitle: true,
        actions: [buildNotificationIcon()],
      ), // end of app bar
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxH20(),
              const Text(
                'Date of dispense | ထုတ်ပေးမည့်ရက်စွဲ (နှစ်-လ-ရက်)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              reusableHotButton(Icons.calendar_month_outlined, getDateText(),
                  () {
                pickDate(context);
              }),
              sizedBoxH10(),
              buildDestinationLabelText(),
              buildDestinationDropdown(),
              sizedBoxH20(),
              buildAvailableItems(),
            ],
          )),
      floatingActionButton: buildCheckOutFab(),
    );
  }

  // notification icon widget
  Widget buildNotificationIcon() {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      IconButton(
          onPressed: () async {
            if (date == null) {
              FormControl.alertDialog(context, 'Date of dispense');
            } else if (selectedDestination == null) {
              FormControl.alertDialog(context, 'Destination');
            }
          },
          icon: const Icon(Icons.local_shipping_outlined)),
      Positioned(
          top: 10,
          left: 1,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
                border: Border.all(color: Colors.black, width: 0.5)),
            child: Text(
              draftCount.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black),
            ),
          ))
    ]);
  }

  // pick date function
  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                      primary: Color.fromARGB(255, 218, 0, 76))),
              child: child!);
        });
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }

  Widget buildAvailableItems() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getAvailableItem(),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item['source_place']}',
                        style: const TextStyle(fontSize: 10)),
                    Text('${item['donor']}',
                        style: const TextStyle(fontSize: 10))
                  ],
                )),
                DataCell(IconButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DraftDispense(
                                    itemName: item['item_name'],
                                    itemType: item['item_type'],
                                    itemId: item['stock_item_id'],
                                    packageFormId:
                                        item['stock_package_form_id'],
                                    expDate: item['stock_exp_date'],
                                    batch: item['stock_batch'],
                                    sourcePlaceId:
                                        item['stock_source_place_id'],
                                    donorId: item['stock_donor_id'],
                                    existingAmount: item['stock_amount'],
                                    packageForm: item['package_form'],
                                  )));
                      if (result == 'success') {
                        DatabaseHelper().getCountDraftStock().then((value) {
                          setState(() {
                            draftCount = value;
                          });
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.outbond_outlined,
                      color: Colors.red,
                      size: 16,
                    ))),
              ]));
            } // filter rows based in search input
            final List<DataRow> filteredRows = rows.where(
              (row) {
                final itemName = row.cells[0].child.toString();
                final itemType = row.cells[1].child.toString();
                final searchQuery = searchController.text.toLowerCase();
                return itemName.toLowerCase().contains(searchQuery) ||
                    itemType.toLowerCase().contains(searchQuery);
              },
            ).toList();
            return Column(children: [
              buildAvailableItemsLabelText(),
              buildSearchTextField(),
              sizedBoxH10(),
              DataTable(
                  columnSpacing: 3,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Item',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Type',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        numeric: true,
                        label: Icon(
                          Icons.tag,
                          size: 16,
                        )),
                    DataColumn(
                        label: Text(
                      'Pkg',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Exp\nနှစ်-လ-ရက်',
                      style:
                          TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Source',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      '',
                    )),
                  ],
                  headingRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 227, 160),
                  ),
                  rows: filteredRows),
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Text(
                'There is no data with available items.\nထုတ်ယူနိုင်သည့်ပစ္စည်းအချက်အလက်များမရှိသေးပါ။');
          }
        });
  }

  Widget buildAvailableItemsLabelText() {
    return const Text('Available Items | ထုတ်ယူနိုင်သည့်ပစ္စည်းများ',
        style: TextStyle(fontWeight: FontWeight.bold));
  }

  // search text field
  Widget buildSearchTextField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: searchController.text.isEmpty
              ? null // not shown if search is empty
              : IconButton(
                  onPressed: clearSearch,
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  )),
          hintText: 'Search Available Item',
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.background, width: 2))),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget buildCheckOutFab() {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      FloatingActionButton.extended(
        onPressed: () async {
          if (date == null) {
            FormControl.alertDialog(context, 'Date of dispense');
          } else if (selectedDestination == null) {
            FormControl.alertDialog(context, 'Destination');
          } else if (draftCount == 0) {
            EasyLoading.showError('ထုတ်ယူရမည့်ပစ္စည်းများကို ဦးစွာရွေးခြယ်ပါ');
          } else {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckoutDispense(
                          stockDate: getDateText(),
                          destinationId: selectedDestination!,
                        )));
            if (result == 'success') {
              DatabaseHelper().getCountDraftStock().then((value) {
                setState(() {
                  draftCount = value;
                });
              });
            }
          }
        },
        label: const Text(
          'ထုတ်ပေးရန်စာရင်း',
          style: TextStyle(
              color: Color.fromARGB(255, 49, 49, 49),
              fontWeight: FontWeight.bold),
        ),
        icon: const Icon(
          Icons.local_shipping_outlined,
          color: Color.fromARGB(255, 49, 49, 49),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 197, 63),
      ),
      Positioned(
          top: 1,
          left: 1,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                border: Border.all(color: Colors.white, width: 0.5)),
            child: Text(
              draftCount.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white),
            ),
          ))
    ]);
  }

  DropdownMenuItem<int> buildDestinationDropdownMenuItem(
          ReusableMenuModel item) =>
      DropdownMenuItem(
        value: item.id,
        child: Text(
          item.name,
          style: const TextStyle(fontSize: 16),
        ),
      );
  Widget buildDestinationLabelText() {
    return const Text('Destination | ပေးပို့ရန်နေရာ',
        style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildDestinationDropdown() {
    return DropdownButtonFormField<int>(
        icon: const Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Colors.grey,
        ),
        value: selectedDestination,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.local_shipping_outlined,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 197, 63), width: 2)),
          contentPadding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
        ),
        hint: const Text('Select destination'),
        items: destinationList.map(buildDestinationDropdownMenuItem).toList(),
        onChanged: (value) => setState(() {
              selectedDestination = value;
            }));
  }
}
