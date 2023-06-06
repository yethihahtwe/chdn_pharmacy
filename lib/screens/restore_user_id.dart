import 'package:flutter/material.dart';

class RestoreUserId extends StatefulWidget {
  const RestoreUserId({super.key});

  @override
  State<RestoreUserId> createState() => _RestoreUserIdState();
}

class _RestoreUserIdState extends State<RestoreUserId> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Restore With User ID'),
        centerTitle: true,
      ),
    );
  }
}
