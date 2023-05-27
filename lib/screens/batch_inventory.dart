import 'package:chdn_pharmacy/screens/reduce_stock.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

class BatchInventory extends StatefulWidget {
  final String itemName;
  final String itemType;
  final int itemId;
  final int batchAmount;
  final String packageForm;
  final int packageFormId;
  final String expDate;
  final String batchNumber;
  final String sourcePlace;
  final int sourcePlaceId;
  final String donor;
  final int donorId;
  const BatchInventory(
      {super.key,
      required this.itemName,
      required this.itemType,
      required this.itemId,
      required this.batchAmount,
      required this.packageForm,
      required this.packageFormId,
      required this.expDate,
      required this.batchNumber,
      required this.sourcePlace,
      required this.sourcePlaceId,
      required this.donor,
      required this.donorId});

  @override
  State<BatchInventory> createState() => _BatchInventoryState();
}

class _BatchInventoryState extends State<BatchInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('${widget.itemName}, ${widget.itemType}'),
        centerTitle: true,
      ), // end of app bar
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sizedBox20(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16),
                Expanded(
                  child: Text(
                    'ယခုစာမျက်နှာတွင် batch တစ်ခုချင်းစီအလိုက် အသေးစိတ်အချက်အလက်များကို ဖော်ပြထားပါသည်။',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            sizedBox20(),
            detailRow('Item Name', widget.itemName),
            const Divider(),
            detailRow('Item Type', widget.itemType),
            const Divider(),
            detailRow('Batch Amount', widget.batchAmount.toString()),
            const Divider(),
            detailRow('Package Form', '${widget.packageForm}(s)'),
            const Divider(),
            detailRow('Expiry Date', widget.expDate),
            const Divider(),
            detailRow('Batch Number', widget.batchNumber),
            const Divider(),
            detailRow('Source Place', widget.sourcePlace),
            const Divider(),
            detailRow('Donor', widget.donor),
            sizedBox20(),
            reusableTwoButtonRow(
                reusableHotButton(Icons.outbound_outlined, 'Dispense',
                    () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReduceStock(
                              stockType: 'OUT',
                              batchAmount: widget.batchAmount,
                              packageForm: widget.packageForm,
                              itemId: widget.itemId,
                              stockPackageFormId: widget.packageFormId,
                              stockExpDate: widget.expDate,
                              stockBatch: widget.batchNumber,
                              stockSourcePlaceId: widget.sourcePlaceId,
                              stockDonorId: widget.donorId)));
                }),
                reusableHotButton(Icons.bolt_outlined, 'Damage', () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReduceStock(
                              stockType: 'DMG',
                              batchAmount: widget.batchAmount,
                              packageForm: widget.packageForm,
                              itemId: widget.itemId,
                              stockPackageFormId: widget.packageFormId,
                              stockExpDate: widget.expDate,
                              stockBatch: widget.batchNumber,
                              stockSourcePlaceId: widget.sourcePlaceId,
                              stockDonorId: widget.donorId)));
                })),
            sizedBox20(),
            Row(
              children: [
                Expanded(
                  child: reusableColdButton('Go Back', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            )
          ])),
    );
  }

  Widget sizedBox20() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget detailRow(String label, String detailValue) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text('$label :'),
        ),
        Expanded(
            flex: 1,
            child: Text(
              detailValue,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
