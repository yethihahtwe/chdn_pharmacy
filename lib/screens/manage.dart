import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/screens/manage_item.dart';
import 'package:chdn_pharmacy/screens/manage_item_type.dart';
import 'package:chdn_pharmacy/screens/update_profile.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';
import 'manage_package_form.dart';

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
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
      // start of app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Warehouse/Clinic Management'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ), // end of app bar
      // start of body
      body: FutureBuilder<String?>(
          future: SharedPrefHelper.getUserId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              return SingleChildScrollView(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // start of edit type card
                        Card(
                          clipBehavior: Clip.hardEdge,
                          elevation: 5,
                          child: InkWell(
                            splashColor: Colors.red.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ManageItemType()));
                            },
                            child: const ListTile(
                              leading: Icon(Icons.type_specimen_outlined),
                              title: Text('Manage Item Types'),
                              subtitle:
                                  Text('ပစ္စည်းအမျိုးအစားများ စီမံခန့်ခွဲရန်'),
                            ),
                          ),
                        ), // end of the edit type card
                        const SizedBox(height: 10),
                        // start of edit item card
                        Card(
                          clipBehavior: Clip.hardEdge,
                          elevation: 5,
                          child: InkWell(
                            splashColor: Colors.red.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ManageItem()));
                            },
                            child: const ListTile(
                              leading: Icon(Icons.medication),
                              title: Text('Manage Items'),
                              subtitle: Text('ပစ္စည်းအမည်များ စီမံခန့်ခွဲရန်'),
                            ),
                          ),
                        ), // end of edit type card
                        const SizedBox(
                          height: 10,
                        ),
                        // start of edit package form card
                        Card(
                          clipBehavior: Clip.hardEdge,
                          elevation: 5,
                          child: InkWell(
                            splashColor: Colors.red.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ManagePackageForm()));
                            },
                            child: const ListTile(
                              leading: Icon(Icons.local_pharmacy_outlined),
                              title: Text('Manage Package Forms'),
                              subtitle:
                                  Text('ထုပ်ပိုးပုံစံများ စီမံခန့်ခွဲရန်'),
                            ),
                          ),
                        ), // end of _specify_ card
                      ]));
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                margin: EdgeInsets.only(
                    top: 20,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 218, 218, 218),
                        width: 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(94, 158, 158, 158),
                          blurRadius: 10.0,
                          offset: Offset(0.0, 1.0)),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Center(
                        child: Image.asset('assets/images/CHDN_LOGO.png'),
                      ),
                    ),
                    const Text(
                        'You have not set your Warehouse/Clinic profile.\nPlease click `Update Profile` button.\nဆေးဂိုဒေါင်/ဆေးခန်းဆိုင်ရာ အချက်အလက်များ မဖြည့်သွင်းရသေးပါ။ `Update Profile` ခလုတ်ကိုနှိပ်၍ဖြည့်သွင်းပါ'),
                    // Start of update profile button
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UpdateProfile()));
                          if (result == 'success') {
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('Update Profile'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.background),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
