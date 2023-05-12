import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';
import 'edit_profile.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  // string values
  String? _userId;
  String? _userName;
  String? _userTownship;
  String? _userVillage;
  String? _userWarehouse;

  @override
  void initState() {
    super.initState();
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
    });
    SharedPrefHelper.getUserName().then((value) {
      setState(() {
        _userName = value;
      });
    });
    SharedPrefHelper.getUserTownship().then((value) {
      setState(() {
        _userTownship = value;
      });
    });
    SharedPrefHelper.getUserVillage().then((value) {
      setState(() {
        _userVillage = value;
      });
    });
    SharedPrefHelper.getUserWarehouse().then((value) {
      _userWarehouse = value;
    });
  }

  // Index for bottom navigation bar
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('My Warehouse/Clinic Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            // start of logo
            SizedBox(
              height: 150,
              child: Center(
                child: Image.asset('assets/images/CHDN_LOGO.png'),
              ),
            ), // end of logo
            // start of user id row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'User ID',
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      _userId ?? 'Not set',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ), // end of user id row
            const SizedBox(
              height: 10,
              child: Divider(),
            ),
            // start of user name row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Incharge Name\nတာဝန်ခံအမည်',
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      _userName ?? 'Not Set',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ), // end of user name row
            const SizedBox(
              height: 10,
              child: Divider(),
            ),
            // start of user township row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Township\nမြို့နယ်',
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      _userTownship ?? 'Not Set',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ), // end of user township row
            const SizedBox(
              height: 10,
              child: Divider(),
            ),
            // start of user village row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Village\nကျေးရွာ',
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      _userVillage ?? 'Not Set',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ), // end of user village row
            const SizedBox(
              height: 10,
              child: Divider(),
            ),
            // start of user warehouse row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Warehouse/Clinic\nဆေးဂိုဒေါင်၊ ဆေးခန်း',
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      _userWarehouse ?? 'Not Set',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ), // end of user warehouse row
            SizedBox(
              height: 10,
              child: Divider(),
            ),
            // start of button row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: // Start of edit profile Button
                      SizedBox(
                    width: 150,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfile()));
                        if (result == 'success') {
                          SharedPrefHelper.getUserId().then((value) {
                            setState(() {
                              _userId = value ?? 'Not Set';
                            });
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 16,
                      ),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 12),
                      ),
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
                    child: SizedBox(
                      width: 10,
                    )),
                Expanded(
                  flex: 2,
                  child: // Start of delete profile Button
                      Visibility(
                    visible: _userId != null,
                    child: SizedBox(
                      width: 150,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Profile'),
                                content: Text(
                                    'Are you sure you want to delete your profile?\nအချက်အလက်များဖျက်ပစ်ရန် သေချာပါသလား?',
                                    style: TextStyle(fontSize: 12)),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      SharedPrefHelper.clearSharedPreferences();
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 16,
                        ),
                        label: const Text('Delete Profile',
                            style: TextStyle(fontSize: 12)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ])),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
