import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // user name controller
  TextEditingController _userNameController = TextEditingController();

  // other village controller
  TextEditingController _otherVilController = TextEditingController();

  // other warehouse controller
  TextEditingController _otherWarehouseController = TextEditingController();

  // dropdown lists
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

  // default for other village
  bool _isOtherVil = false;

  // default to show village dropdown
  bool _showVilDropdown = true;

  // default for other warehouse
  bool _isOtherWarehouse = false;

  // default to show warehouse dropdown
  bool _showWarehouseDropdown = true;

  // for save and preload
  String? _selectedUserTownship;
  String? _selectedUserVillage;
  String? _selectedUserWarehouse;
  String _userId = '';
  GlobalKey<FormState> _key = GlobalKey();

  // save data
  Future<void> updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', _userId);
    await prefs.setString('userName', _userNameController.text);
    await prefs.setString('userTownship', _selectedUserTownship ?? '');
    await prefs.setString('userVillage', _selectedUserVillage ?? '');
    await prefs.setBool('isOtherVillage', _isOtherVil);
    await prefs.setString('userWarehouse', _selectedUserWarehouse ?? '');
    await prefs.setBool('isOtherWarehouse', _isOtherWarehouse);
  }

  @override
  void initState() {
    super.initState();

    // load saved user name
    SharedPrefHelper.getUserName().then(
        (value) => _userNameController = TextEditingController(text: value));

    // load saved user township
    SharedPrefHelper.getUserTownship()
        .then((value) => _selectedUserTownship = value);

    // load saved user village
    SharedPrefHelper.getUserVillage()
        .then((value) => _selectedUserVillage = value);

    // load is other village
    SharedPrefHelper.getIsOtherVillage().then((value) => _isOtherVil);

    // load saved user warehouse
    SharedPrefHelper.getUserWarehouse()
        .then((value) => _selectedUserWarehouse = value);

    // load is other warehouse
    SharedPrefHelper.getIsOtherWarehouse().then((value) => _isOtherWarehouse);
  }

  // // dispose text controller
  // @override
  // void dispose() {
  //   _userNameController.dispose();
  //   _otherVilController.dispose();
  //   _otherWarehouseController.dispose();
  // }

  // build widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // start of user name
              const Text('Incharge/ တာဝန်ခံအမည်'),
              TextFormField(
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
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter Incharge Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              // end of user name
              // Start of user township
              const Text('Township/ မြို့နယ်'),
              DropdownButtonFormField<String>(
                  icon: Icon(Icons.arrow_drop_down_circle_outlined),
                  value: _selectedUserTownship,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select township';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.only(top: 5, bottom: 5, right: 10),
                  ),
                  hint: const Text('Please select Township'),
                  items: townshipListItems.map(buildTownshipListItem).toList(),
                  onChanged: (value) => setState(() {
                        _selectedUserTownship = value;
                        _selectedUserVillage = null;
                        _selectedUserWarehouse = null;
                        _isOtherVil = false;
                        _isOtherWarehouse = false;
                      })),
              const SizedBox(height: 10.0),
              // End of user township
              // Start of user village
              const Text('Village/ ကျေးရွာ'),
              if (_showVilDropdown)
                DropdownButtonFormField<String>(
                    icon: Icon(Icons.arrow_drop_down_circle_outlined),
                    value: _selectedUserVillage,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select village';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.map),
                      border: OutlineInputBorder(),
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
                        })),
              const SizedBox(height: 10),
              // End of village
              // Start of village not found checkbox
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Village not found?/ ကျေးရွာရှာမတွေ့?'),
                value: _isOtherVil,
                onChanged: (value) => setState(() {
                  _isOtherVil = value!;
                  if (_isOtherVil) {
                    _showVilDropdown = false;
                    _selectedUserVillage = null;
                  } else {
                    _showVilDropdown = true;
                  }
                }),
              ), // end of village not found checkbox
              // Start of other village
              if (_isOtherVil)
                TextFormField(
                  controller: _otherVilController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter village name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _otherVilController.text = value!;
                    _selectedUserVillage = value;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.map),
                    hintText: 'Please enter village name',
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 10.0),
              // end of other village
              // Start of warehouse
              const Text('Warehouse/Clinic/ ဆေးဂိုဒေါင်/ဆေးခန်း'),
              if (_showWarehouseDropdown)
                DropdownButtonFormField<String>(
                    icon: Icon(Icons.arrow_drop_down_circle_outlined),
                    value: _selectedUserWarehouse,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Warehouse/Clinic';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    ),
                    hint: const Text('Please select warehouse/clinic'),
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
              // End of warehouse
              // Start of warehouse not found checkbox
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                    'Warehouse/Clinic not found? ဆေးဂိုဒေါင်/ဆေးခန်းရှာမတွေ့?'),
                value: _isOtherWarehouse,
                onChanged: (value) => setState(() {
                  _isOtherWarehouse = value!;
                  if (_isOtherWarehouse) {
                    _showWarehouseDropdown = false;
                    _selectedUserWarehouse = null;
                  } else {
                    _showWarehouseDropdown = true;
                  }
                }),
              ), // end of warehouse not found checkbox
              // Start of other warehouse
              if (_isOtherWarehouse)
                TextFormField(
                  controller: _otherWarehouseController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter warehouse/clinic';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _otherWarehouseController.text = value!;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    hintText: 'Please enter Warehouse/Clinic',
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 10.0), // end of other warehouse
              // Start of Save Button
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_key.currentState != null &&
                        _key.currentState!.validate() &&
                        (_selectedUserTownship != '' ||
                            _selectedUserVillage != '' ||
                            _selectedUserWarehouse != '')) {
                      _key.currentState?.save();
                      await UpdateProfile();
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
                  label: const Text('Save'),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
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
}
