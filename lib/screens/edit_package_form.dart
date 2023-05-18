// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../model/data_model.dart';

class EditPackageForm extends StatefulWidget {
  final String packageFormName;
  final int packageFormId;
  const EditPackageForm(
      {super.key, required this.packageFormName, required this.packageFormId});

  @override
  State<EditPackageForm> createState() => _EditPackageFormState();
}

class _EditPackageFormState extends State<EditPackageForm> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // controller
  final TextEditingController _packageFormNameController =
      TextEditingController();

  // to prevent duplicate
  List<String> _packageFormList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _packageFormNameController.text = widget.packageFormName;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Edit Package Form'),
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
              const Text('Package Form\nထုပ်ပိုးပုံစံ'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _packageFormNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter package form';
                    }
                    if (widget.packageFormName != value &&
                        _packageFormList.contains(
                            value.toLowerCase().replaceAll(' ', ''))) {
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
                      hintText: 'Enter Package Form',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of package form
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: // Start of save Button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            _key.currentState?.save();
                            await DatabaseHelper().updatePackageForm(
                                PackageForm.updatePackageForm(
                                    packageFormName:
                                        _packageFormNameController.text),
                                widget.packageFormId);
                            Navigator.pop(context, 'success');
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.background),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                        child: const Text('Save',
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text('Delete?'),
                                        content: const Text(
                                          'ထုပ်ပိုးပုံစံဖျက်ပစ်ရန် သေချာပါသလား',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () async {
                                                await DatabaseHelper()
                                                    .deletePackageForm(
                                                        widget.packageFormId);
                                                Navigator.pop(context);
                                                Navigator.pop(
                                                    context, 'success');
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              )),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ]);
                                  });
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(const BorderSide(
                                  color: Colors.red, width: 2)),
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ))),
                  )
                ],
              )
            ])),
      ),
    );
  }
}
