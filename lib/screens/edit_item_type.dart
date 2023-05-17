import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../model/data_model.dart';

class EditItemType extends StatefulWidget {
  final int itemTypeId;
  final String itemTypeName;
  const EditItemType(
      {super.key, required this.itemTypeName, required this.itemTypeId});

  @override
  State<EditItemType> createState() => _EditItemTypeState();
}

class _EditItemTypeState extends State<EditItemType> {
  // form key
  GlobalKey<FormState> _key = GlobalKey();

  // controllers
  TextEditingController _itemTypeController = TextEditingController();

  // load passed data
  @override
  void initState() {
    super.initState();
    setState(() {
      _itemTypeController.text = widget.itemTypeName;
    });
  }

  // build widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Edit Item Type'),
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
              const Text('Item Type/ ပစ္စည်းအမျိုးအစား'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _itemTypeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item type';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _itemTypeController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Item Type',
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
                    child: // Start of update Button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate()) {
                            _key.currentState?.save();
                            await DatabaseHelper().updateItemType(
                                ItemType.updateItemType(
                                    itemTypeName: _itemTypeController.text),
                                widget.itemTypeId);
                            Navigator.pop(context, 'success');
                          }
                        },
                        child: const Text(
                          'Save',
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
                    child: // Start of delete Button
                        SizedBox(
                            width: 200,
                            height: 45,
                            child: TextButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Item Type?'),
                                          content: Text(
                                              'Are you sure you want to delete item type?\nပစ္စည်းအမျိုးအစားကိုဖျက်ရန် သေချာပါသလား?',
                                              style: TextStyle(fontSize: 12)),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () async {
                                                  await DatabaseHelper()
                                                      .deleteItemType(
                                                          widget.itemTypeId);
                                                  Navigator.pop(context);
                                                  Navigator.pop(
                                                      context, 'success');
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                )),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: const Text(
                                  'Delete',
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
