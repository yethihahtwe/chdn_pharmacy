import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:flutter/material.dart';

import '../model/data_model.dart';

class EditSourcePlace extends StatefulWidget {
  final String sourcePlaceName;
  final int sourcePlaceId;
  const EditSourcePlace(
      {super.key, required this.sourcePlaceName, required this.sourcePlaceId});

  @override
  State<EditSourcePlace> createState() => _EditSourcePlaceState();
}

class _EditSourcePlaceState extends State<EditSourcePlace> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();
  // controller
  final TextEditingController _sourcePlaceNameController =
      TextEditingController();

  // check for duplicates
  List<String> _sourcePlaceList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _sourcePlaceNameController.text = widget.sourcePlaceName;
    });
    DatabaseHelper().getAllSourcePlace().then((value) {
      setState(() {
        _sourcePlaceList = List<String>.from(value.map((e) =>
            e['source_place_name']
                .toString()
                .toLowerCase()
                .replaceAll(' ', '')));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Edit Source Place'),
        centerTitle: true,
      ), // end of app bar
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
              const Text('Source Place\nရရှိရာနေရာ'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _sourcePlaceNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter source place name';
                    }
                    if (widget.sourcePlaceName != value &&
                        _sourcePlaceList.contains(
                            value.toLowerCase().replaceAll(' ', ''))) {
                      return '$value is already in source places.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _sourcePlaceNameController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        Icons.system_update_alt,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Source Place',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of source place
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
                            await DatabaseHelper().updateSourcePlace(
                                SourcePlace.updateSourcePlace(
                                    sourcePlaceName:
                                        _sourcePlaceNameController.text),
                                widget.sourcePlaceId);
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
                                          'ရရှိရာနေရာဖျက်ပစ်ရန် သေချာပါသလား',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () async {
                                                await DatabaseHelper()
                                                    .deleteSourcePlace(
                                                        widget.sourcePlaceId);
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
