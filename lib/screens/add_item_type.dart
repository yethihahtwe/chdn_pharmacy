import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:chdn_pharmacy/model/data_model.dart';
import '../database/database_helper.dart';

class AddItemType extends StatefulWidget {
  const AddItemType({super.key});

  @override
  State<AddItemType> createState() => _AddItemTypeState();
}

class _AddItemTypeState extends State<AddItemType> {
  // form key
  GlobalKey<FormState> _key = GlobalKey();

  // user id
  String? _userId;

  // controllers
  TextEditingController _itemTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add Item Type'),
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
              const Text('New Item Type/ပစ္စည်းအမျိုးအစားသစ်'),
              SizedBox(
                height: 50,
                // start of item type text form field
                child: TextFormField(
                  controller: _itemTypeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new item type';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemTypeController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(
                        Icons.type_specimen,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter New Item Type',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of item type text form field
              const SizedBox(
                height: 20,
              ),
              // start of buttons row
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
                            await DatabaseHelper().insertItemType(
                                ItemType.insertItemType(
                                    itemTypeName: _itemTypeController.text,
                                    itemTypeEditable: 'true',
                                    itemTypeCre: _userId!));
                            Navigator.pop(context, 'success');
                          }
                        },
                        child: const Text(
                          'Add Item Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.background),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox(width: 10)),
                  Expanded(
                    flex: 2,
                    child: // Start of _specify_ Button
                        SizedBox(
                            width: 200,
                            height: 45,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      BorderSide(color: Colors.red, width: 2)),
                                ))),
                  ),
                ],
              ),
            ])),
      ),
    );
  }
}
