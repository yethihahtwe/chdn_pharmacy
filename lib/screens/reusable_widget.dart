import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:flutter/material.dart';

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
      return '${pickedDate!.day}-${pickedDate!.month}-${pickedDate!.year}';
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
                            Text('${widget.dateType}: '),
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
  const EditStockNonDate({super.key, required this.fieldNameToEdit});

  @override
  State<EditStockNonDate> createState() => _EditStockNonDateState();
}

class _EditStockNonDateState extends State<EditStockNonDate> {
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
                      // start of
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
