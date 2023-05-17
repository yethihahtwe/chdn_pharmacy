import 'package:flutter/material.dart';

class EditPackageForm extends StatefulWidget {
  final String packageFormName;
  final int packageFormId;
  const EditPackageForm(
      {super.key, required this.packageFormName, required this.packageFormId});

  @override
  State<EditPackageForm> createState() => _EditPackageFormState();
}

class _EditPackageFormState extends State<EditPackageForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
