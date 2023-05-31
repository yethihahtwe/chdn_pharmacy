import 'dart:convert';

import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratedQR extends StatefulWidget {
  final int destinationId;
  final String stockDate;
  final String destinationName;
  const GeneratedQR(
      {super.key,
      required this.destinationId,
      required this.stockDate,
      required this.destinationName});

  @override
  State<GeneratedQR> createState() => _GeneratedQRState();
}

class _GeneratedQRState extends State<GeneratedQR> {
  // to show query result
  List<Map<String, dynamic>> settledList = [];

  @override
  void initState() {
    super.initState();
    DatabaseHelper()
        .getDispenseBatch(widget.destinationId, widget.stockDate)
        .then((value) {
      settledList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String jsonData = jsonEncode(settledList);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Generate QR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sizedBoxH20(),
            buildTitleText(),
            sizedBoxH20(),
            Text(jsonData),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2)),
                child: QrImageView(
                  data: jsonData,
                  version: QrVersions.auto,
                  size: 320,
                  gapless: false,
                ),
              ),
            )
          ])),
    );
  }

  Widget buildTitleText() {
    return Text(
      '${widget.stockDate} တွင် ${widget.destinationName} သို့ ထုတ်ပေးသည့်ပစ္စည်းများ',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
