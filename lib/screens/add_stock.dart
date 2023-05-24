import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();
// user id
  String? _userId;

  // date
  DateTime? date;
  // validate if date is picked
  bool _isDatePicked = false;
  // display date in date picker button
  String getDateText() {
    if (date == null) {
      _isDatePicked = false;
      return 'Select Date';
    } else {
      _isDatePicked = true;
      return '${date!.day}-${date!.month}-${date!.year}';
    }
  }

  // date value to save
  String saveDateText() {
    if (date == null) {
      return '';
    } else {
      return '${date!.day}-${date!.month}-${date!.year}';
    }
  }

  // source place
  // save source place
  int? _selectedSourcePlace;
  // source place dropdown options
  List<SourcePlaceMenu> _sourcePlaceList = [];

  // donor
  // save donor
  int? _selectedDonor;
  // donor dropdown options
  List<DonorMenu> _donorList = [];

  // item type
  String? _selectedItemType;
  // dropdown options
  List<String> _itemTypeList = [];

  // item
  bool _searchEnabled = false;
  int? _selectedItem;
  List<ItemMenu> _itemList = [];
  final TextEditingController itemNameController = TextEditingController();
// clear text field when clear button pressed
  void _clearSearch() {
    itemNameController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    itemNameController.dispose();
  }

  // exp date
  DateTime? _expDate;
  // to validate
  bool _isExpDatePicked = false;
  // display exp date
  String getExpDateText() {
    if (_expDate == null) {
      _isExpDatePicked = false;
      return 'Select Expiry Date';
    } else {
      _isExpDatePicked = true;
      return '${_expDate!.day}-${_expDate!.month}-${_expDate!.year}';
    }
  }

  // save exp date
  String saveExpDateText() {
    if (_expDate == null) {
      return '';
    } else {
      return '${_expDate!.day}-${_expDate!.month}-${_expDate!.year}';
    }
  }

  // show exp date picker
  bool _showExpDatePicker = true;
  // no exp date
  bool _hasNoExpDate = false;

  // batch no
  final TextEditingController _batchNameController = TextEditingController();
  // show batch text form field
  bool _showBatchNumber = true;
  // no batch number
  bool _hasNoBatchNumber = false;

  // package form
  int? _selectedPackageForm;
  List<PackageFormMenu> _packageFormList = [];

  // amount
  final TextEditingController _amountController = TextEditingController();
  String _selectedPackageFormText = 'Package Form';

  // remark
  final TextEditingController _remarkController = TextEditingController();

  // validate error text
  bool _itemNotValid = false;
  bool _dateNotValid = false;
  bool _expDateNotValid = false;

  @override
  void initState() {
    super.initState();
    // load user id
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
    });
    // // load last date
    SharedPrefHelper.getLastDate().then((value) {
      if (value != null) {
        setState(() {
          date = DateFormat('dd-MM-yyyy').parse(value);
        });
      }
    });

    // load last source place
    SharedPrefHelper.getLastSourcePlace().then((value) {
      setState(() {
        _selectedSourcePlace = value;
      });
    });
    // load last donor
    SharedPrefHelper.getLastDonor().then((value) {
      setState(() {
        _selectedDonor = value;
      });
    });
    // Load source place query to List
    DatabaseHelper().getAllSourcePlace().then((value) {
      setState(() {
        _sourcePlaceList = value
            .map((e) => SourcePlaceMenu(
                  e['source_place_id'] as int,
                  e['source_place_name'].toString(),
                ))
            .toList();
      });
    });
    // load donor query to list
    DatabaseHelper().getAllDonor().then((value) {
      setState(() {
        _donorList = value
            .map((e) => DonorMenu(
                  e['donor_id'] as int,
                  e['donor_name'].toString(),
                ))
            .toList();
      });
    });

    // Load list of item type string value
    DatabaseHelper().getAllItemType().then((value) {
      setState(() {
        _itemTypeList =
            List<String>.from(value.map((e) => e['item_type_name'].toString()));
      });
    });

    // load query to item list
    DatabaseHelper()
        .getAllItemByItemType(_selectedItemType ?? '')
        .then((value) {
      setState(() {
        _itemList = value
            .map(
                (e) => ItemMenu(e['item_id'] as int, e['item_name'].toString()))
            .toList();
      });
    });

    // load query to package form
    DatabaseHelper().getAllPackageForm().then((value) {
      setState(() {
        _packageFormList = value
            .map((e) => PackageFormMenu(
                e['package_form_id'] as int, e['package_form_name'].toString()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add Stock'),
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
              // start of date picker
              const Text('Stock-in Date | ပစ္စည်းအဝင်ရက်စွဲ'),
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 227, 160),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary)),
                    onPressed: () {
                      pickDate(context);
                    },
                    icon: const Icon(Icons.calendar_today, size: 19),
                    label: Text(getDateText(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
              ), // end of date picker
              if (_dateNotValid)
                const Text('Please select date',
                    style: TextStyle(color: Colors.red, fontSize: 12)),
              const SizedBox(height: 10),
              // Start of item type dropdown
              const Text('Item Type | ပစ္စည်းအမျိုးအစား'),
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
                      Icons.type_specimen_outlined,
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
                  items: _itemTypeList.map(buildItemTypeListMenuItem).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _searchEnabled = true;
                      });
                    }
                    setState(() {
                      _selectedItemType = value;
                      _clearSearch();
                      DatabaseHelper()
                          .getAllItemByItemType(_selectedItemType ?? '')
                          .then((value) {
                        setState(() {
                          _itemList = value
                              .map((e) => ItemMenu(e['item_id'] as int,
                                  e['item_name'].toString()))
                              .toList();
                        });
                      });
                    });
                  }),
              // End of item type
              const SizedBox(height: 10.0),
              // start of item
              const Text('Item and Composition | ပစ္စည်းအမည်နှင့်ပါဝင်မှုပမာဏ'),
              DropdownMenu<int>(
                  width: 300,
                  enabled: _searchEnabled,
                  controller: itemNameController,
                  enableFilter: true,
                  enableSearch: true,
                  requestFocusOnTap: true,
                  leadingIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  trailingIcon: itemNameController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clearSearch,
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                            size: 18,
                          )),
                  hintText: 'Item name and composition',
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 197, 63),
                            width: 2)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    suffixIconColor: Colors.grey,
                  ),
                  initialSelection: _selectedItem,
                  onSelected: (value) {
                    setState(() {
                      _selectedItem = value;
                    });
                  },
                  dropdownMenuEntries:
                      _itemList.map(buildItemListMenuEntry).toList()),
              // end of item menu
              if (_itemNotValid)
                const Text('Please select item',
                    style: TextStyle(color: Colors.red, fontSize: 12)),
              const SizedBox(height: 10),
              // start of source place
              const Text('Source | လက်ခံရရှိရာနေရာ'),
              DropdownButtonFormField<int>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  value: _selectedSourcePlace,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select source place';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.system_update_alt,
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
                  hint: const Text('Select Source'),
                  items: _sourcePlaceList
                      .map(buildSourcePlaceListMenuItem)
                      .toList(),
                  onChanged: (value) => setState(() {
                        _selectedSourcePlace = value;
                      })),
              // End of source place
              const SizedBox(height: 10.0),
              // start of donor
              const Text('Donor | အလှူရှင်အဖွဲ့အစည်း'),
              DropdownButtonFormField<int>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  value: _selectedDonor,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select donor';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.contact_mail,
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
                  hint: const Text('Select Donor'),
                  items: _donorList.map(buildDonorListMenuItem).toList(),
                  onChanged: (value) => setState(() {
                        _selectedDonor = value;
                      })), // end of donor
              const SizedBox(height: 10),

              // start of package form
              const Text('Package Form | ထုပ်ပိုးပုံစံ'),
              DropdownButtonFormField<int>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  value: _selectedPackageForm,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select package form';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.local_pharmacy_outlined,
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
                  hint: const Text('Select Package Form'),
                  items: _packageFormList
                      .map(buildPackageFormListMenuItem)
                      .toList(),
                  onChanged: (value) => setState(() {
                        _selectedPackageForm = value;
                        _selectedPackageFormText =
                            '${_packageFormList.firstWhere((element) => element.id == value, orElse: () => PackageFormMenu(0, '')).name}(s)';
                      })), // end of package form
              const SizedBox(height: 10),
              // start of exp date
              if (_showExpDatePicker)
                const Text('Expiry Date | သက်တမ်းလွန်ရက်စွဲ'),
              if (_showExpDatePicker)
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 227, 160),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary)),
                      onPressed: () {
                        pickExpDate(context);
                      },
                      icon: const Icon(Icons.calendar_today, size: 19),
                      label: Text(getExpDateText(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                ), // end of exp date
              if (_expDateNotValid)
                const Text('Please select expiry date',
                    style: TextStyle(color: Colors.red, fontSize: 12)),
              // start of no exp date checkbox
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'No Expiry Date | သက်တမ်းလွန်ရက်စွဲမရှိ',
                  style: TextStyle(fontSize: 12),
                ),
                value: _hasNoExpDate,
                onChanged: (value) => setState(() {
                  _hasNoExpDate = value!;
                  if (_hasNoExpDate) {
                    _showExpDatePicker = false;
                    _expDate = null;
                    _expDateNotValid = false;
                  } else {
                    _showExpDatePicker = true;
                  }
                }),
              ), // end of no exp date checkbox
              const Divider(),
              // const SizedBox(height: 10),
              // start of batch
              if (_showBatchNumber) const Text('Batch Number'),
              if (_showBatchNumber)
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _batchNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter batch number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _batchNameController.text = value!;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(
                          Icons.more_outlined,
                          color: Colors.grey,
                        ),
                        hintText: 'Enter Batch Number',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.background,
                                width: 2))),
                    maxLines: 1,
                  ),
                ), // end of batch
              // start of no batch checkbox
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'No Batch Number | Batch Number မရှိ',
                  style: TextStyle(fontSize: 12),
                ),
                value: _hasNoBatchNumber,
                onChanged: (value) => setState(() {
                  _hasNoBatchNumber = value!;
                  if (_hasNoBatchNumber) {
                    _showBatchNumber = false;
                    _batchNameController.text = '';
                  } else {
                    _showBatchNumber = true;
                  }
                }),
              ), // end of no batch checkbox
              const Divider(),
              // const SizedBox(
              //   height: 10,
              // ),
              // start of amount
              const Text('Stock Amount | အရေအတွက်'),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: TextFormField(
                      controller: _amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter stock amount';
                        }
                        if (double.tryParse(value)! < 0) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _amountController.text = value!;
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          prefixIcon: const Icon(
                            Icons.format_list_numbered_rounded,
                            color: Colors.grey,
                          ),
                          hintText: 'Enter Amount',
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  width: 2))),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(_selectedPackageFormText),
                ],
              ), // end of stock amount
              const SizedBox(
                height: 10,
              ),
              // start of remark
              const Text('Remark | မှတ်ချက်'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _remarkController,
                  onSaved: (value) {
                    _remarkController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        Icons.note,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Remark',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  expands: true,
                  minLines: null,
                  maxLines: null,
                ),
              ), // end of remark
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
                              _key.currentState!.validate() &&
                              _isDatePicked &&
                              (_isExpDatePicked || _hasNoExpDate) &&
                              (_batchNameController.text.isNotEmpty ||
                                  _hasNoBatchNumber) &&
                              _selectedItem != null) {
                            _key.currentState?.save();
                            await saveStock();
                            EasyLoading.showSuccess(
                                'ပစ္စည်းအဝင်မှတ်တမ်း သိမ်းဆည်းပြီးပါပြီ');
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, 'success');
                          } else {
                            await validateForm();
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
              ), // end of button row
              const SizedBox(
                height: 50,
              )
            ])),
      ),
    );
  }

  // pick date function
  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 218, 0, 76),
            )),
            child: child!);
      },
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
      _isDatePicked = true;
    });
  }

  // build source place menu items
  DropdownMenuItem<int> buildSourcePlaceListMenuItem(SourcePlaceMenu item) =>
      DropdownMenuItem(
          value: item.id,
          child: Text(
            item.name,
            style: const TextStyle(fontSize: 15),
          ));

// build donor menu items
  DropdownMenuItem<int> buildDonorListMenuItem(DonorMenu item) =>
      DropdownMenuItem(
          value: item.id,
          child: Text(
            item.name,
            style: const TextStyle(fontSize: 15),
          ));
  // build item type menu items
  DropdownMenuItem<String> buildItemTypeListMenuItem(String item) =>
      DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 15),
          ));
  // build item menu items
  DropdownMenuEntry<int> buildItemListMenuEntry(ItemMenu item) =>
      DropdownMenuEntry(value: item.id, label: item.name);

  // build package form menu items
  DropdownMenuItem<int> buildPackageFormListMenuItem(PackageFormMenu item) =>
      DropdownMenuItem<int>(
          value: item.id,
          child: Text(
            item.name,
            style: const TextStyle(fontSize: 15),
          ));

// exp date pick function
  Future pickExpDate(BuildContext context) async {
    final initialExpDate = DateTime.now();
    final newExpDate = await showDatePicker(
      context: context,
      initialDate: initialExpDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 218, 0, 76),
            )),
            child: child!);
      },
    );
    if (newExpDate == null) return;
    setState(() {
      _expDate = newExpDate;
      _isExpDatePicked = true;
    });
  }

  // save function
  Future saveStock() async {
    await DatabaseHelper().insertStock(Stock.insertStock(
        stockDate: saveDateText(),
        stockType: 'IN',
        stockItemId: _selectedItem!,
        stockPackageFormId: _selectedPackageForm!,
        stockExpDate: saveExpDateText(),
        stockBatch: _batchNameController.text,
        stockAmount: int.tryParse(_amountController.text) ?? 0,
        stockSourcePlaceId: _selectedSourcePlace!,
        stockDonorId: _selectedDonor!,
        stockRemark: _remarkController.text,
        stockTo: 0,
        stockSync: '',
        stockCre: _userId!));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastDate', saveDateText());
    await prefs.setInt('lastSourcePlace', _selectedSourcePlace!);
    await prefs.setInt('lastDonor', _selectedDonor!);
  }

  // validate function
  Future validateForm() async {
    if (date == null) {
      setState(() {
        _dateNotValid = true;
      });
    }
    if (_expDate == null && !_hasNoExpDate) {
      setState(() {
        _expDateNotValid = true;
      });
    }
    if (_selectedItem == null) {
      setState(() {
        _itemNotValid = true;
      });
    }
  }
}
