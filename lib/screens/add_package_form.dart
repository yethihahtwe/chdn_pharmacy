import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/model/data_model.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class AddPackageForm extends StatefulWidget {
  const AddPackageForm({super.key});

  @override
  State<AddPackageForm> createState() => _AddPackageFormState();
}

class _AddPackageFormState extends State<AddPackageForm> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // controller
  final TextEditingController _packageFormNameController =
      TextEditingController();

  // to prevent duplicate
  List<String> _packageFormList = [];

  // user id
  String? _userId;

  @override
  void initState() {
    super.initState();
    // load query to list to prevent duplicate
    DatabaseHelper().getAllPackageForm().then((value) {
      setState(() {
        _packageFormList = List<String>.from(value.map((e) =>
            e['package_form_name']
                .toString()
                .toLowerCase()
                .replaceAll(' ', '')));
      });
    });
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add New Package Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              // start of package form name
              const Text('New Package Form\nထုပ်ပိုးပုံစံသစ်အမည်'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _packageFormNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new package form';
                    }
                    if (_packageFormList
                        .contains(value.toLowerCase().replaceAll(' ', ''))) {
                      return '$value is already in package forms.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _packageFormNameController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        Icons.local_pharmacy_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter New Package Form',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of package form name
              const SizedBox(
                height: 20,
              ),
              // start of button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: // Start of add Button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            _key.currentState?.save();

                            await DatabaseHelper().insertPackageForm(
                                PackageForm.insertPackageForm(
                                    packageFormName:
                                        _packageFormNameController.text,
                                    packageFormEditable: 'true',
                                    packageFormCre: _userId!));
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, 'success');
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add New',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.background),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox(width: 10)),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                        width: 200,
                        height: 45,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(const BorderSide(
                                  color: Colors.red, width: 2)),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ))),
                  ),
                ],
              ),
            ])),
      ),
    );
  }
}
