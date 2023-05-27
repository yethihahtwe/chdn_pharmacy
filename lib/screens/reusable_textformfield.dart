import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

class ReusableTextFormField extends StatefulWidget {
  final String label;
  final bool isNumberKeyboard;
  final TextEditingController controller;
  final String hintText;
  final IconData iconName;
  final String? Function(String?)? validator;
  const ReusableTextFormField({
    super.key,
    required this.label,
    required this.isNumberKeyboard,
    required this.controller,
    required this.hintText,
    required this.iconName,
    this.validator,
  });

  @override
  State<ReusableTextFormField> createState() => _ReusableTextFormFieldState();
}

class _ReusableTextFormFieldState extends State<ReusableTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        sizedBoxH10(),
        SizedBox(
            height: 50,
            child: TextFormField(
                keyboardType: widget.isNumberKeyboard
                    ? TextInputType.number
                    : TextInputType.text,
                controller: widget.controller,
                validator: widget.validator,
                onSaved: (value) {
                  widget.controller.text = value!;
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    prefixIcon: Icon(widget.iconName, color: Colors.grey),
                    hintText: widget.hintText,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 197, 63),
                            width: 2))),
                maxLines: 1))
      ],
    );
  }
}
