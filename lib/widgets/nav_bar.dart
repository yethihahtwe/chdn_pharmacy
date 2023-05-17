import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const BottomNavigation(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(
            icon: Icon(Icons.manage_search), label: 'Manage'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
      ],
      currentIndex: selectedIndex,
      onTap: (value) {
        if (value != selectedIndex) {
          if (value == 0) {
            Navigator.pushNamed(context, '/');
          }
          if (value == 1) {
            Navigator.pushNamed(context, 'history');
          }
          if (value == 2) {
            Navigator.pushNamed(context, 'manage');
          }
          if (value == 3) {
            Navigator.pushNamed(context, 'profile');
          }
          if (value == 4) {
            Navigator.pushNamed(context, 'info');
          }
        }
      },
    );
  }
}
