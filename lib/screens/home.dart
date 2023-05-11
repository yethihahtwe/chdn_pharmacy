import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/screens/update_profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // to check profile setup
  bool? _hasSetProfile;

  @override
  void initState() {
    super.initState();
    // load existing userId
    SharedPrefHelper.getUserId().then(
      (value) {
        if (value == null) {
          setState(() {
            _hasSetProfile = false;
          });
        } else {
          setState(() {
            _hasSetProfile = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('My Inventory'),
        centerTitle: true,
      ),
      body: Text('Please Update Your Profile'),
    );
  }
}
