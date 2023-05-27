// start of reusable dropdown
import 'package:flutter/material.dart';

import '../model/data_model.dart';

class ReusableDropdown extends StatefulWidget {
  final List<ReusableMenuModel> reusableList;
  final String label;
  final int? queryValue;
  final IconData iconName;
  final ValueChanged<int?>? onChanged;
  const ReusableDropdown(
      {super.key,
      required this.reusableList,
      required this.label,
      required this.iconName,
      required this.queryValue,
      this.onChanged});

  @override
  State<ReusableDropdown> createState() => _ReusableDropdownState();
}

class _ReusableDropdownState extends State<ReusableDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<int>(
          icon: const Icon(
            Icons.arrow_drop_down_circle_outlined,
            color: Colors.grey,
          ),
          value: widget.queryValue,
          validator: (value) {
            if (value == null) {
              return 'Please select ${widget.label}';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.iconName,
              color: Colors.grey,
            ),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 197, 63), width: 2)),
            contentPadding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
          ),
          hint: Text('Select ${widget.label}'),
          items: widget.reusableList.map(buildReusableListMenuItem).toList(),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        )
      ],
    );
  }

  DropdownMenuItem<int> buildReusableListMenuItem(ReusableMenuModel item) =>
      DropdownMenuItem(
          value: item.id,
          child: Text(item.name, style: const TextStyle(fontSize: 15)));
}
