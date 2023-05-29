import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'reusable_function.dart';

class DraftDispense extends StatefulWidget {
  final String itemName;
  final String itemType;
  final int itemId;
  final int packageFormId;
  final String packageForm;
  final String expDate;
  final String batch;
  final int sourcePlaceId;
  final int donorId;
  final int existingAmount;

  const DraftDispense(
      {super.key,
      required this.itemName,
      required this.itemType,
      required this.itemId,
      required this.packageFormId,
      required this.expDate,
      required this.batch,
      required this.sourcePlaceId,
      required this.donorId,
      required this.existingAmount,
      required this.packageForm});

  @override
  State<DraftDispense> createState() => _DraftDispenseState();
}

class _DraftDispenseState extends State<DraftDispense> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();
  // controllers
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  // user id
  String? userId;
  // prevent duplicates
  int? sameItemDraftStock;
  @override
  void initState() {
    super.initState();
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
    DatabaseHelper().getSameItemDraftStock(widget.itemId).then((value) {
      setState(() {
        sameItemDraftStock = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('${widget.itemName}, ${widget.itemType}'),
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
              buildAmountLabel(),
              buildAmountTextFormField(),
              sizedBoxH20(),
              buildRemarkLabel(),
              buildRemarkTextFormField(),
              sizedBoxH20(),
              reusableTwoButtonRow(
                  reusableHotButton(Icons.save_alt_outlined, 'Save', () async {
                    if (sameItemDraftStock! > 0) {
                      await FormControl.alertDialog(
                          context, 'not the same item again');
                    } else if (amountController.text.isNotEmpty &&
                        int.tryParse(amountController.text)! >
                            widget.existingAmount) {
                      await FormControl.alertDialog(
                          context, 'amount not to exceed existing amount');
                    } else if (_key.currentState != null &&
                        _key.currentState!.validate()) {
                      _key.currentState?.save();
                      await EditStock.insertStockData(
                          '',
                          'OUT',
                          widget.itemId,
                          widget.packageFormId,
                          widget.expDate,
                          widget.batch,
                          -1 * (int.tryParse(amountController.text)!),
                          widget.sourcePlaceId,
                          widget.donorId,
                          remarkController.text,
                          null,
                          null,
                          userId!,
                          'true');
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

  Widget buildAlertInfoRow() {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16),
        Expanded(
            child: Text(
          'ယခု batch အတွက် အများဆုံးထုတ်ယူနိုင်သည့်အရေအတွက်မှာ ${widget.existingAmount.toString()} ${widget.packageForm}(s) ဖြစ်ပါသည်။',
          style: const TextStyle(fontSize: 10),
        ))
      ],
    );
  }

  Widget buildAmountLabel() {
    return const Text('Amount to dispense | ထုတ်ယူလိုသည့်အရေအတွက်',
        style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildAmountTextFormField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: amountController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter amount';
          }
          return null;
        },
        onSaved: (value) {
          amountController.text = value!;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            hintText: 'Enter amount to dispense',
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.background,
                    width: 2))),
        maxLines: 1,
      ),
    );
  }

  Widget buildRemarkLabel() {
    return const Text('Remark | မှတ်ချက်',
        style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildRemarkTextFormField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: remarkController,
        onSaved: (value) {
          remarkController.text = value!;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: const Icon(
              Icons.note,
              color: Colors.grey,
            ),
            hintText: 'Enter remark if present',
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
