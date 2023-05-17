import 'package:flutter/material.dart';

class EditItem extends StatefulWidget {
  final String itemName;
  final String itemType;
  final int itemId;
  const EditItem(
      {super.key,
      required this.itemName,
      required this.itemType,
      required this.itemId});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
