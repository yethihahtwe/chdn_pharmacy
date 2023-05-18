import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/model/data_model.dart';
import 'package:flutter/material.dart';

class AddSourcePlace extends StatefulWidget {
  const AddSourcePlace({super.key});

  @override
  State<AddSourcePlace> createState() => _AddSourcePlaceState();
}

class _AddSourcePlaceState extends State<AddSourcePlace> {
  // controller
  final TextEditingController _sourcePlaceNameController =
      TextEditingController();

  // user id
  String? _userId;

  // prevent duplicate
  List<String> _sourcePlaceList = [];

  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
    });
    DatabaseHelper().getAllSourcePlace().then((value) {
      _sourcePlaceList = List<String>.from(value.map((e) =>
          e['source_place_name'].toString().toLowerCase().replaceAll(' ', '')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add New Source Place'),
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
              const Text('Source Place\nရရှိရာနေရာအမည်'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _sourcePlaceNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter source place';
                    }
                    if (_sourcePlaceList
                        .contains(value.toLowerCase().replaceAll(' ', ''))) {
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
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            _key.currentState?.save();
                            await DatabaseHelper().insertSourcePlace(
                                SourcePlace.insertSourcePlace(
                                    sourcePlaceName:
                                        _sourcePlaceNameController.text,
                                    sourcePlaceEditable: 'true',
                                    sourcePlaceCre: _userId!));
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
