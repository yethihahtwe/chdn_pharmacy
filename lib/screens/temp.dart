import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

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
        destinationName = value!['destination_name'];
      });
    });

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
            ])),
      );
    }
  }

  Widget buildDestinationNameText() {
    return Text(destinationName!);
  }
}
