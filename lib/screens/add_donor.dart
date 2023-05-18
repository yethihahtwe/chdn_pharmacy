import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:flutter/material.dart';

import '../model/data_model.dart';

class AddDonor extends StatefulWidget {
  const AddDonor({super.key});

  @override
  State<AddDonor> createState() => _AddDonorState();
}

class _AddDonorState extends State<AddDonor> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // controller
  final TextEditingController _donorNameController = TextEditingController();

  // user id
  String? _userId;

  // prevent duplicates
  List<String> _donorNameList = [];

  @override
  void initState() {
    super.initState();
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
    });
    DatabaseHelper().getAllDonor().then((value) {
      setState(() {
        _donorNameList = List<String>.from(value.map((e) =>
            e['donor_name'].toString().toLowerCase().replaceAll(' ', '')));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add New Donor'),
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
              const Text('Donor/ အလှူရှင်အဖွဲ့အစည်းအမည်'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _donorNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter donor';
                    }
                    if (_donorNameList
                        .contains(value.toLowerCase().replaceAll(' ', ''))) {
                      return '$value is already in donors.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _donorNameController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        Icons.contact_mail,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Donor',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of donor name
              const SizedBox(height: 20),
              // start of button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: // Start of save Button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            _key.currentState?.save();
                            await DatabaseHelper().insertDonor(
                                Donor.insertDonor(
                                    donorName: _donorNameController.text,
                                    donorEditable: 'true',
                                    donorCre: _userId!));
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, 'success');
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add',
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
