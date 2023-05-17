import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/model/data_model.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  // form key
  GlobalKey<FormState> _key = GlobalKey();

  // user id
  String? _userId;
  // item type
  String? _selectedItemType;

  // controllers
  TextEditingController _itemNameController = TextEditingController();

  // dropdown options
  List<String> itemTypeList = [];

  @override
  void initState() {
    super.initState();
    // Load volunteer list into volunteer dropdown
    DatabaseHelper().getAllItemType().then((value) {
      setState(() {
        itemTypeList =
            List<String>.from(value.map((e) => e['item_type_name'].toString()));
      });
    });

    // load user id
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
        title: const Text('Add Item'),
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
              const Text('Item and composition\nပစ္စည်းအမည်နှင့်ပါဝင်မှုပမာဏ'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _itemNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemNameController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(
                        Icons.medication_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Item Name',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of item name
              SizedBox(height: 10),
              // Start of item type dropdown
              const Text('Item Type, ပစ္စည်းအမျိုးအစား'),
              DropdownButtonFormField<String>(
                  icon: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  value: _selectedItemType,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select item type';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.type_specimen,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 197, 63),
                            width: 2)),
                    contentPadding:
                        EdgeInsets.only(top: 5, bottom: 5, right: 10),
                  ),
                  hint: const Text('Select Item Type'),
                  items: itemTypeList.map(buildItemTypeListMenuItem).toList(),
                  onChanged: (value) => setState(() {
                        _selectedItemType = value;
                      })),
              const SizedBox(height: 10.0),
              // End of item type dropdown
              const SizedBox(height: 20),
              // start of button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: // Start of _specify_ Button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            _key.currentState?.save();
                            await DatabaseHelper().insertItem(Item.insertItem(
                                itemName: _itemNameController.text,
                                itemType: _selectedItemType!,
                                itemEditable: 'true',
                                itemCre: _userId!));
                            Navigator.pop(context, 'success');
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.background),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(width: 10),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
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

  DropdownMenuItem<String> buildItemTypeListMenuItem(String item) =>
      DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 15),
          ));
}
