import 'package:chdn_pharmacy/screens/history.dart';
import 'package:chdn_pharmacy/screens/home.dart';
import 'package:chdn_pharmacy/screens/info.dart';
import 'package:chdn_pharmacy/screens/other_profile.dart';
import 'package:chdn_pharmacy/screens/profile_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// root of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        'history': (context) => const History(),
        'profile': (context) => const ProfileDetail(),
        'other_profile': (context) => const OtherProfile(),
        'info': (context) => const Info(),
      },
      theme: ThemeData(
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 14.0),
            titleLarge: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
                fontSize: 14.0, color: Color.fromARGB(255, 57, 57, 57)),
          ),
          primaryColor: Color.fromARGB(255, 218, 0, 76),
          highlightColor: Color.fromARGB(107, 218, 0, 76),
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Color.fromARGB(255, 255, 197, 63),
            accentColor: const Color.fromARGB(255, 49, 49, 49),
          )),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
