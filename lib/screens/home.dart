import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/screens/update_profile.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Index for bottom navigation bar
  int _selectedIndex = 0;
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
        title: const Text('My Inventory'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<String?>(
        future: SharedPrefHelper.getUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            return Scaffold(
              body: Text('test'),
            );
          } else {
            return Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Center(
                      child: Image.asset('assets/images/CHDN_LOGO.png'),
                    ),
                  ),
                  Text(
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
                                builder: (context) => UpdateProfile()));
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              margin: EdgeInsets.only(
                  top: 20,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 218, 218, 218),
                      width: 1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(94, 158, 158, 158),
                        blurRadius: 10.0,
                        offset: Offset(0.0, 1.0)),
                  ]),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
