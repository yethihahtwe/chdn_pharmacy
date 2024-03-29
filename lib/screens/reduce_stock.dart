import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_dropdown.dart';
import 'package:chdn_pharmacy/screens/reusable_function.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/data_model.dart';

class ReduceStock extends StatefulWidget {
  final String stockType;
  final int batchAmount;
  final String packageForm;
  final int itemId;
  final int stockPackageFormId;
  final String stockExpDate;
  final String stockBatch;
  final int stockSourcePlaceId;
  final int stockDonorId;

  const ReduceStock(
      {super.key,
      required this.stockType,
      required this.batchAmount,
      required this.packageForm,
      required this.itemId,
      required this.stockPackageFormId,
      required this.stockExpDate,
      required this.stockBatch,
      required this.stockSourcePlaceId,
      required this.stockDonorId});

  @override
  State<ReduceStock> createState() => _ReduceStockState();
}

class _ReduceStockState extends State<ReduceStock> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // date picker
  DateTime? date;
  // for form validation
  bool _isDatePicked = false;
  String getDateText() {
    if (date == null) {
      _isDatePicked = false;
      return 'Select Date';
    } else {
      _isDatePicked = true;
      return '${date!.day}-${date!.month}-${date!.year}';
    }
  }

  String? _stockDescribe;

  // controller
  TextEditingController controller = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  // dropdown list
  List<ReusableMenuModel> reusableList = [];
  int? selectedReusableValue;

  // user id
  String? userId;

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getAllReusable('tbl_destination').then((value) {
      setState(() {
        reusableList = value
            .map((e) => ReusableMenuModel(
                e['destination_id'] as int, e['destination_name'].toString()))
            .toList();
      });
    });
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
    // string to display in info text
    if (widget.stockType == 'OUT') {
      setState(() {
        _stockDescribe = 'ထုတ်ယူနိုင်သည့်';
      });
    } else if (widget.stockType == 'DMG') {
      setState(() {
        _stockDescribe = 'ပျက်စီးစာရင်းသွင်းနိုင်သည့်';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: buildAppBarTitle(),
        centerTitle: true,
      ), // end of app bar
      body: Form(
        key: _key,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sizedBoxH20(),
              buildAlertInfoRow(),
              sizedBoxH20(),
              buildDateLabel(),
              reusableHotButton(Icons.calendar_month_outlined, getDateText(),
                  () {
                pickDate(context);
              }),
              sizedBoxH10(),
              buildAmountLabel(),
              buildAmountTextFormField(),
              sizedBoxH10(),
              buildPackageFormLabel(),
              sizedBoxH10(),
              if (widget.stockType == 'OUT') buildDestinationDropdown(),
              sizedBoxH10(),
              buildRemarkLabel(),
              buildRemarkTextFormField(),
              sizedBoxH20(),
              reusableTwoButtonRow(
                  reusableHotButton(
                      widget.stockType == 'OUT'
                          ? Icons.outbond_outlined
                          : widget.stockType == 'DMG'
                              ? Icons.bolt_outlined
                              : null,
                      widget.stockType == 'OUT'
                          ? 'Save Dispense'
                          : widget.stockType == 'DMG'
                              ? 'Save Damage'
                              : '', () async {
                    if (!_isDatePicked) {
                      await FormControl.alertDialog(context, 'Date');
                    } else if (controller.text.isNotEmpty &&
                        int.tryParse(controller.text)! > widget.batchAmount) {
                      await FormControl.alertDialog(
                          context, 'Amount not to exceed remaining');
                    } else if (_key.currentState != null &&
                        _key.currentState!.validate() &&
                        _isDatePicked) {
                      _key.currentState?.save();
                      await EditStock.insertStockData(
                          getDateText(),
                          widget.stockType,
                          widget.itemId,
                          widget.stockPackageFormId,
                          widget.stockExpDate,
                          widget.stockBatch,
                          -1 * (int.tryParse(controller.text)!),
                          widget.stockSourcePlaceId,
                          widget.stockDonorId,
                          remarkController.text,
                          selectedReusableValue,
                          '',
                          userId!,
                          'settled');
                      EasyLoading.showSuccess(widget.stockType == 'OUT'
                          ? 'ပစ္စည်းထုတ်ယူမှတ်တမ်း သိမ်းဆည်းပြီးပါပြီ။'
                          : widget.stockType == 'DMG'
                              ? 'ပစ္စည်းပျက်စီးမှတ်တမ်း သိမ်းဆည်းပြီးပါပြီ။'
                              : '');
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, 'success');
                    }
                  }),
                  reusableColdButton('Cancel', () {
                    Navigator.pop(context);
                  }))
            ])),
      ),
    );
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
              primary: Color.fromARGB(255, 218, 0, 76),
            )),
            child: child!);
      },
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }

  Widget buildAppBarTitle() {
    return Row(
      children: [
        Icon(widget.stockType == 'OUT'
            ? Icons.outbond_outlined
            : widget.stockType == 'DMG'
                ? Icons.bolt_outlined
                : null),
        Text(widget.stockType == 'OUT'
            ? 'Dispense Item/ ပစ္စည်းထုတ်ရန်'
            : widget.stockType == 'DMG'
                ? 'Damaged Item/ ပျက်စီးစာရင်းသွင်းရန်'
                : ''),
      ],
    );
  }

  Widget buildAlertInfoRow() {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16),
        Expanded(
            child: Text(
          'ယခု batch အတွက် အများဆုံး$_stockDescribeအရေအတွက်မှာ ${widget.batchAmount.toString()} ${widget.packageForm}(s) ဖြစ်ပါသည်။',
          style: const TextStyle(fontSize: 10),
        ))
      ],
    );
  }

  Widget buildDateLabel() {
    return Text(
        widget.stockType == 'OUT'
            ? 'Date of dispense/ ထုတ်ယူသည့်ရက်စွဲ'
            : widget.stockType == 'DMG'
                ? 'Date of damage/ ပျက်စီးသည့်ရက်စွဲ'
                : '',
        style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildPackageFormLabel() {
    return Row(
      children: [
        const Text('Package Form: ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('${widget.packageForm}(s)'),
      ],
    );
  }

  Widget buildRemarkLabel() {
    return Text(
        widget.stockType == 'OUT'
            ? 'Remark/ မှတ်ချက်'
            : widget.stockType == 'DMG'
                ? 'Cause of the damage/ ပျက်စီးရသည့်အကြောင်းရင်း'
                : '',
        style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildAmountLabel() {
    return Text(
        widget.stockType == 'OUT'
            ? 'Amount of dispense/ ထုတ်ယူသည့်အရေအတွက်'
            : widget.stockType == 'DMG'
                ? 'Amount of damage/ ပျက်စီးသည့်အရေအတွက်'
                : '',
        style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildAmountTextFormField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter dispensed amount';
          }
          return null;
        },
        onSaved: (value) {
          controller.text = value!;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: const Icon(
              Icons.tag,
              color: Colors.grey,
            ),
            hintText: 'Please enter dispensed amount',
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.background,
                    width: 2))),
        maxLines: 1,
      ),
    );
  }

  Widget buildDestinationDropdown() {
    return ReusableDropdown(
      reusableList: reusableList,
      label: 'Destination/ ပေးပို့ရာနေရာ',
      iconName: Icons.airport_shuttle_outlined,
      queryValue: null,
      onChanged: (value) {
        selectedReusableValue = value;
      },
    );
  }

  Widget buildRemarkTextFormField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: remarkController,
        validator: widget.stockType == 'DMG'
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter cause of damage';
                }
                return null;
              }
            : null,
        onSaved: (value) {
          remarkController.text = value!;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: const Icon(
              Icons.note,
              color: Colors.grey,
            ),
            hintText: widget.stockType == 'OUT'
                ? 'Remark if any'
                : widget.stockType == 'DMG'
                    ? 'Please enter cause of the damage'
                    : '',
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.background,
                    width: 2))),
        maxLines: 1,
      ),
    );
  }
}
