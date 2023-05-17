// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {super.key,
      required this.userName,
      required this.userTownship,
      required this.isOtherVillage,
      required this.userVillage,
      required this.isOtherWarehouse,
      required this.userWarehouse});
  final String userName;
  final String userTownship;
  final bool isOtherVillage;
  final String userVillage;
  final bool isOtherWarehouse;
  final String userWarehouse;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // controllers
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userVillageController = TextEditingController();
  TextEditingController _userWarehouseController = TextEditingController();

  // dropdown selected values
  String? _selectedUserTownship;
  String? _selectedUserVillage;
  bool _isOtherVillage = false;
  bool _showVilDropdown = true;
  String? _selectedUserWarehouse;
  bool _isOtherWarehouse = false;
  bool _showWarehouseDropdown = true;

  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // dropdown options
  // township
  final townshipListItems = ['Demoso', 'Loikaw', 'Mese', 'Pruso'];

  // village
  Map<String, List<String>> vilListItems = {
    'Demoso': ['Demoso_vil1', 'Demoso_vil2', 'Demoso_vil3'],
    'Loikaw': ['Loikaw_vil1', 'Loikaw_vil2', 'Loikaw_vil3'],
    'Mese': ['Mese_vil1', 'Mese_vil2', 'Mese_vil3'],
    'Pruso': ['Pruso_vil1', 'Pruso_vil2', 'Pruso_vil3']
  };

  // warehouse
  Map<String, List<String>> warehouseListItems = {
    'Demoso_vil1': ['vil1_wh1', 'vil1_wh2', 'vil1_wh3'],
    'Demoso_vil2': ['vil2_wh1', 'vil2_wh2', 'vil2_wh3'],
    'Demoso_vil3': ['vil3_wh1', 'vil3_wh2', 'vil3_wh3'],
    'Loikaw_vil1': ['vil1_wh1', 'vil1_wh2', 'vil1_wh3'],
    'Loikaw_vil2': ['vil2_wh1', 'vil2_wh2', 'vil2_wh3'],
    'Loikaw_vil3': ['vil3_wh1', 'vil3_wh2', 'vil3_wh3'],
    'Mese_vil1': ['vil1_wh1', 'vil1_wh2', 'vil1_wh3'],
    'Mese_vil2': ['vil2_wh1', 'vil2_wh2', 'vil2_wh3'],
    'Mese_vil3': ['vil3_wh1', 'vil3_wh2', 'vil3_wh3'],
    'Pruso_vil1': ['vil1_wh1', 'vil1_wh2', 'vil1_wh3'],
    'Pruso_vil2': ['vil2_wh1', 'vil2_wh2', 'vil2_wh3'],
    'Pruso_vil3': ['vil3_wh1', 'vil3_wh2', 'vil3_wh3'],
  };

  // init state
  @override
  void initState() {
    super.initState();
    // preload user name
    setState(() {
      _userNameController = TextEditingController(text: widget.userName);
    });
    // preload user township
    setState(() {
      _selectedUserTownship = widget.userTownship;
    });
    // preload user village for other village
    if (widget.isOtherVillage) {
      setState(() {
        _isOtherVillage = true;
        _showVilDropdown = false;
        _userVillageController =
            TextEditingController(text: widget.userVillage);
      });
    } else {
      // preload user village for dropdown selcted village
      setState(() {
        _isOtherVillage = false;
        _showVilDropdown = true;
        _selectedUserVillage = widget.userVillage;
      });
    }
    // preload user warehouse if other warehouse
    if (widget.isOtherWarehouse) {
      setState(() {
        _isOtherWarehouse = true;
        _showWarehouseDropdown = false;
        _userWarehouseController =
            TextEditingController(text: widget.userWarehouse);
      });
    } else {
      // preload user warehouse for dropdown selected warehouse
      setState(() {
        _isOtherWarehouse = false;
        _showWarehouseDropdown = true;
        _selectedUserWarehouse = widget.userWarehouse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Edit Profile'),
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              // start of user name
              const Text('Incharge/ တာဝန်ခံအမည်'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter incharge name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userNameController.text = value!;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Incharge Name',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background,
                              width: 2))),
                  maxLines: 1,
                ),
              ), // end of user name
              const SizedBox(height: 10.0),
              // Start of township
              const Text('Township/ မြို့နယ်'),
              DropdownButtonFormField<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  value: _selectedUserTownship,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select township';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.map,
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
                  hint: const Text('Please select Township'),
                  items: townshipListItems.map(buildTownshipListItem).toList(),
                  onChanged: (value) => setState(() {
                        _selectedUserTownship = value;
                        _selectedUserVillage = null;
                        _isOtherVillage = false;
                        _showVilDropdown = true;
                        _selectedUserWarehouse = null;
                        _isOtherWarehouse = false;
                        _showWarehouseDropdown = true;
                      })),
              const SizedBox(height: 10.0),
              // End of user township
              // Start of user village
              const Text('Village/ ကျေးရွာ'),
              if (_showVilDropdown) // start of dropdown
                DropdownButtonFormField<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.grey,
                    ),
                    value: _selectedUserVillage,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select village';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.map,
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
                    hint: const Text('Please select Village'),
                    items: _selectedUserTownship == null
                        ? []
                        : vilListItems[_selectedUserTownship!]!
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 15),
                                )))
                            .toList(),
                    onChanged: (value) => setState(() {
                          _selectedUserVillage = value;
                          _selectedUserWarehouse = null;
                        })), // End of village dropdown
              // Start of other village check box
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Village not found? ကျေးရွာရှာမတွေ့?',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isOtherVillage,
                onChanged: (value) => setState(() {
                  _isOtherVillage = value!;
                  if (_isOtherVillage) {
                    _showVilDropdown = false;
                    _selectedUserVillage = null;
                    _userVillageController.text = '';
                  } else {
                    _showVilDropdown = true;
                  }
                }),
              ), // end of other village checkbox
              // start of other village text form field
              if (_isOtherVillage)
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _userVillageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter village';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _selectedUserVillage = value!;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(
                          Icons.map,
                          color: Colors.grey,
                        ),
                        hintText: 'Please enter village',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.background,
                                width: 2))),
                    maxLines: 1,
                  ),
                ), // end of other village text form field
              const SizedBox(height: 10),
              // Start of warehouse dropdown
              const Text('Warehouse/Clinic, ဆေးဂိုဒေါင်/ဆေးခန်း'),
              if (_showWarehouseDropdown)
                DropdownButtonFormField<String>(
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    value: _selectedUserWarehouse,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select warehouse/clinic';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    ),
                    hint: const Text('Please select Warehouse/Clinic'),
                    items: _selectedUserVillage == null
                        ? []
                        : warehouseListItems[_selectedUserVillage!]!
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 15),
                                )))
                            .toList(),
                    onChanged: (value) => setState(() {
                          _selectedUserWarehouse = value;
                        })),
              const SizedBox(height: 10),
// End of warehouse dropdown
// start of other warehouse check box
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Warehouse/Clinic not found?, ဆေးဂိုဒေါင်/ဆေးခန်းရှာမတွေ့?',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isOtherWarehouse,
                onChanged: (value) => setState(() {
                  _isOtherWarehouse = value!;
                  if (_isOtherWarehouse) {
                    _showWarehouseDropdown = false;
                    _selectedUserWarehouse = null;
                    _userWarehouseController.text = '';
                  } else {
                    _showWarehouseDropdown = true;
                  }
                }),
              ), // end of other warehouse checkbox
              // start of other warehouse text form field
              if (_isOtherWarehouse)
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _userWarehouseController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter warehouse/clinic';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _selectedUserWarehouse = value!;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: const Icon(
                          Icons.location_city,
                          color: Colors.grey,
                        ),
                        hintText: 'Enter warehouse/clinic',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.background,
                                width: 2))),
                    maxLines: 1,
                  ),
                ), // end of other warehouse text form field
              const SizedBox(height: 20),
              // start of button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: // start of save button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_key.currentState != null &&
                              _key.currentState!.validate() &&
                              (_selectedUserTownship != null ||
                                  _selectedUserVillage != null ||
                                  _selectedUserWarehouse != null)) {
                            _key.currentState?.save();
                            await saveEditedProfile();
                            Navigator.pop(context, 'success');
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Please enter the required values'),
                                    content: const Text(
                                      'အချက်အလက်များ ပြည့်စုံစွာရွေးခြယ်ဖြည့်သွင်းပါ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK')),
                                    ],
                                  );
                                });
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text(
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
                  ), // end of save button
                  const Expanded(
                    flex: 1,
                    child: SizedBox(width: 10),
                  ),
                  Expanded(
                    flex: 2,
                    child: // start of cancel button
                        SizedBox(
                      width: 200,
                      height: 45,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 255, 255, 255)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.red),
                            side: MaterialStateProperty.all(const BorderSide(
                                width: 2.0, color: Colors.red))),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ])),
      ),
    );
  }

  // build township list item
  DropdownMenuItem<String> buildTownshipListItem(String item) =>
      DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 15),
          ));

  // save edited data
  Future<void> saveEditedProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userNameController.text);
    await prefs.setString('userTownship', _selectedUserTownship!);
    await prefs.setString('userVillage', _selectedUserVillage!);
    await prefs.setString('userWarehouse', _selectedUserWarehouse!);
    await prefs.setBool('isOtherVillage', _isOtherVillage);
    await prefs.setBool('isOtherWarehouse', _isOtherWarehouse);
  }
}
