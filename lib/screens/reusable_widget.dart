import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_dropdown.dart';
import 'package:chdn_pharmacy/screens/reusable_function.dart';
import 'package:flutter/material.dart';

import '../model/data_model.dart';

class EditStockDate extends StatefulWidget {
  final String dateType;
  final String dateValue;
  final int stockId;
  final String tableName;
  final String columnName;
  final String idColumn;
  const EditStockDate(
      {super.key,
      required this.dateType,
      required this.dateValue,
      required this.stockId,
      required this.tableName,
      required this.columnName,
      required this.idColumn});

  @override
  State<EditStockDate> createState() => _EditStockDateState();
}

class _EditStockDateState extends State<EditStockDate> {
  DateTime? pickedDate;
  String _getDateText() {
    if (pickedDate == null) {
      return widget.dateValue;
    } else {
      String day = pickedDate!.day.toString().padLeft(2, '0');
      String month = pickedDate!.month.toString().padLeft(2, '0');
      String year = pickedDate!.year.toString();
      return '$year-$month-$day';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Edit ${widget.dateType}'),
        centerTitle: true,
      ), // end of app bar
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // start of date Row
                        Row(
                          children: [
                            Text('${widget.dateType}\n(နှစ်-လ-ရက်): '),
                            const SizedBox(width: 5),
                            Text(_getDateText(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(5),
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 218, 0, 76),
                                    )),
                                onPressed: () {
                                  _pickDate(context);
                                },
                                child: const Text('Select Date',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ), // end of date row
                        // start of button row
                        Row(
                          children: [
                            TextButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(5),
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 255, 197, 63),
                                    )),
                                onPressed: () {
                                  DatabaseHelper().updateSingleValue(
                                      widget.tableName,
                                      widget.columnName,
                                      widget.idColumn,
                                      _getDateText(),
                                      widget.stockId);
                                  Navigator.pop(context, 'success');
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        )
                      ]),
                ),
              ),
            ],
          )),
    );
  }

  //pick date function
  Future _pickDate(BuildContext context) async {
    final _initialDate = DateTime.now();
    final _newDate = await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 218, 0, 76),
              )),
              child: child!);
        });
    if (_newDate == null) return;
    setState(() {
      pickedDate = _newDate;
    });
  }
}

class EditStockNonDate extends StatefulWidget {
  final String fieldNameToEdit;
  final queryValue;
  final IconData iconName;
  final String columnName;
  final int id;
  final bool isNumberKeyboard;
  const EditStockNonDate(
      {super.key,
      required this.fieldNameToEdit,
      required this.iconName,
      required this.queryValue,
      required this.columnName,
      required this.id,
      required this.isNumberKeyboard});

  @override
  State<EditStockNonDate> createState() => _EditStockNonDateState();
}

class _EditStockNonDateState extends State<EditStockNonDate> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller.text = widget.queryValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Edit ${widget.fieldNameToEdit}'),
          centerTitle: true,
        ), // end of app bar
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              reusableTextFormField(widget.fieldNameToEdit, controller,
                  widget.iconName, widget.isNumberKeyboard),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: reusableHotButton(
                          Icons.system_update_alt, 'Update', () async {
                        EditStock.saveStockData('tbl_stock', widget.columnName,
                            'stock_id', controller.text, widget.id);
                        Navigator.pop(context, 'success');
                      })),
                  const Expanded(flex: 1, child: SizedBox(width: 10)),
                  Expanded(
                      flex: 2,
                      child: reusableColdButton('Cancel', () {
                        Navigator.pop(context);
                      }))
                ],
              )
            ],
          ),
        ));
  }
}

Widget sizedBoxH20() {
  return const SizedBox(height: 20);
}

Widget sizedBoxH10() {
  return const SizedBox(height: 10);
}

Widget sizedBoxW10() {
  return const SizedBox(width: 10);
}

Widget reusableTextFormField(String label, TextEditingController controller,
    IconData iconName, bool isNumberKeyboard) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 50,
        child: TextFormField(
          keyboardType:
              isNumberKeyboard ? TextInputType.number : TextInputType.text,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
          onSaved: (value) {
            controller.text = value!;
          },
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: Icon(
                iconName,
                color: Colors.grey,
              ),
              hintText: 'Enter  $label',
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 197, 63), width: 2))),
          maxLines: 1,
        ),
      ),
    ],
  );
} // end of reusable text form field

// start of edit stock with dropdown
class EditStockDropdown extends StatefulWidget {
  final int stockId;
  final String fieldNameToEdit;
  final int queryValue;
  final IconData iconName;
  final String dropdownTableName;
  final String dropdownIdColumn;
  final String dropdownNameColumn;
  final String columnName;
  final VoidCallback? onStockUpdated;
  const EditStockDropdown(
      {super.key,
      required this.dropdownTableName,
      required this.dropdownIdColumn,
      required this.dropdownNameColumn,
      required this.fieldNameToEdit,
      required this.queryValue,
      required this.iconName,
      required this.stockId,
      required this.columnName,
      this.onStockUpdated});

  @override
  State<EditStockDropdown> createState() => _EditStockDropdownState();
}

class _EditStockDropdownState extends State<EditStockDropdown> {
  List<ReusableMenuModel> reusableList = [];
  int? selectedReusableValue;

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getAllReusable(widget.dropdownTableName).then((value) {
      setState(() {
        reusableList = value
            .map((e) => ReusableMenuModel(e[widget.dropdownIdColumn] as int,
                e[widget.dropdownNameColumn].toString()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.fieldNameToEdit),
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
            ReusableDropdown(
              reusableList: reusableList,
              label: widget.fieldNameToEdit,
              iconName: widget.iconName,
              queryValue: widget.queryValue,
              onChanged: (value) {
                setState(() {
                  selectedReusableValue = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: reusableHotButton(Icons.system_update_alt, 'Update',
                      () async {
                    EditStock.saveStockData('tbl_stock', widget.columnName,
                        'stock_id', selectedReusableValue, widget.stockId);
                    if (widget.onStockUpdated != null) {
                      widget.onStockUpdated!();
                    }
                    Navigator.pop(context);
                  }),
                ),
                const Expanded(flex: 1, child: SizedBox(width: 10)),
                Expanded(
                    flex: 2,
                    child: reusableColdButton('Cancel', () {
                      Navigator.pop(context);
                    }))
              ],
            )
          ])),
    );
  }
}
// end of edit stock with dropdown

Widget reusableHotButton(
    IconData? iconName, String label, VoidCallback onPressed) {
  return SizedBox(
    width: 200,
    height: 45,
    child: ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 255, 197, 63),
          ),
          foregroundColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 49, 49, 49),
          )),
      onPressed: onPressed,
      icon: Icon(iconName),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}

Widget reusableColdButton(String label, VoidCallback onPressed) {
  return SizedBox(
      width: 200,
      height: 45,
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.red, width: 2)),
          ),
          child: Text(
            label,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          )));
}

Widget reusableTwoButtonRow(Widget hotButton, Widget coldButton) {
  return Row(
    children: [
      Expanded(flex: 2, child: hotButton),
      const Expanded(flex: 1, child: SizedBox(width: 10)),
      Expanded(flex: 2, child: coldButton)
    ],
  );
}

Widget reusableForeignKeyConstraintMessage(
    String fieldToEdit, BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          size: 14,
        ),
        Expanded(
          child: Text(
            '$fieldToEdit ကို ပြင်လျှင်ဖြစ်စေ၊ ဖျက်လျှင်ဖြစ်စေ ၎င်း $fieldToEdit ကိုမှတ်သားထားသည့် အခြားမှတ်တမ်းများ၌ပါ ပြောင်းလဲခြင်း၊ ပျက်ခြင်းဖြစ်နိုင်ပါသည်',
            style: const TextStyle(fontSize: 10),
            softWrap: true,
          ),
        )
      ],
    ),
  );
}
