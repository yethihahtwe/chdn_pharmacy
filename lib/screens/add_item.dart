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
  final GlobalKey<FormState> _key = GlobalKey();

  // user id
  String? _userId;
  // item type
  String? _selectedItemType;

  // controllers
  final TextEditingController _itemNameController = TextEditingController();

  // dropdown options
  List<String> itemTypeList = [];

  Future checkForDuplicates() async {
    const column1 = 'item_name';
    const column2 = 'item_type';
    final value1 = _itemNameController.text.toLowerCase().replaceAll(' ', '');
    final value2 = _selectedItemType!.toLowerCase().replaceAll(' ', '');
    final duplicateCount = await DatabaseHelper()
        .itemDuplicateCount(column1, column2, value1, value2);
    if (duplicateCount > 0) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Duplicate!'),
              content: Text(
                '$value1, $value2 already present!',
                style: const TextStyle(fontSize: 12),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ]);
        },
      );
    } else {
      await DatabaseHelper().insertItem(Item.insertItem(
          itemName: _itemNameController.text,
          itemType: _selectedItemType!,
          itemEditable: 'true',
          itemCre: _userId!));
      // ignore: use_build_context_synchronously
      Navigator.pop(context, 'success');
    }
  }

  @override
  void initState() {
    super.initState();
    // Load item type list into item type dropdown
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
        title: const Text('Add New Item'),
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
              const Text(
                  'New Item and Composition\nပစ္စည်းသစ်အမည်နှင့်ပါဝင်မှုပမာဏ'),
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
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        Icons.medication_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Item Name',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of item name
              const SizedBox(height: 10),
              // Start of item type dropdown
              const Text('Item Type, ပစ္စည်းအမျိုးအစား'),
              DropdownButtonFormField<String>(
                  icon: const Icon(
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
                    child: // Start of update Button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            checkForDuplicates();
                            _key.currentState?.save();
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
                  const Expanded(
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

  DropdownMenuItem<String> buildItemTypeListMenuItem(String item) =>
      DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 15),
          ));
}
