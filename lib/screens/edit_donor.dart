import 'package:chdn_pharmacy/model/data_model.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class EditDonor extends StatefulWidget {
  final String donorName;
  final int donorId;
  const EditDonor({super.key, required this.donorName, required this.donorId});

  @override
  State<EditDonor> createState() => _EditDonorState();
}

class _EditDonorState extends State<EditDonor> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // controller
  final TextEditingController _donorNameController = TextEditingController();

  // check duplicate
  List<String> _donorNameList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _donorNameController.text = widget.donorName;
    });
    // load query to list to prevent duplicate
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
        title: const Text('Edit Donor'),
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
              const Text('Donor\nအလှူရှင်အဖွဲ့အစည်းအမည်'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _donorNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter donor';
                    }
                    if (widget.donorName != value &&
                        _donorNameList.contains(
                            value.toLowerCase().replaceAll(' ', ''))) {
                      return '$value is already in donors';
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
              const SizedBox(
                height: 20,
              ),
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
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            _key.currentState?.save();
                            await DatabaseHelper().updateDonor(
                                Donor.updateDonor(
                                    donorName: _donorNameController.text),
                                widget.donorId);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, 'success');
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.background),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                        child: const Text('Update',
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
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text('Delete?'),
                                        content: const Text(
                                          'အလှူရှင်အဖွဲ့အစည်းအမည်ဖျက်ပစ်ရန် သေချာပါသလား?',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () async {
                                                await DatabaseHelper()
                                                    .deleteDonor(
                                                        widget.donorId);
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                                // ignore: use_build_context_synchronously
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
                  ),
                ],
              ),
            ])),
      ),
    );
  }
}
