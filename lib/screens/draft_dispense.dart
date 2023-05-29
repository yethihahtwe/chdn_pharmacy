import 'package:flutter/material.dart';

class DraftDispense extends StatefulWidget {
  final String itemName;
  final String itemType;
  final int itemId;
  final int packageFormId;
  final String expDate;
  final String batch;
  final int sourcePlaceId;
  final int donorId;

  const DraftDispense(
      {super.key,
      required this.itemName,
      required this.itemType,
      required this.itemId,
      required this.packageFormId,
      required this.expDate,
      required this.batch,
      required this.sourcePlaceId,
      required this.donorId});

  @override
  State<DraftDispense> createState() => _DraftDispenseState();
}

class _DraftDispenseState extends State<DraftDispense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
