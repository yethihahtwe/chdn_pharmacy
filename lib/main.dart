import 'dart:io';

import 'package:chdn_pharmacy/screens/history.dart';
import 'package:chdn_pharmacy/screens/home.dart';
import 'package:chdn_pharmacy/screens/info.dart';
import 'package:chdn_pharmacy/screens/manage.dart';
import 'package:chdn_pharmacy/screens/profile_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // create new database in working directory
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'pharmacy.db');

  // checking the database already exists
  if (!await File(path).exists())
  // copy the database
  {
    ByteData data = await rootBundle
        .load(join('assets', 'databases', 'pharmacy_preload.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
  }

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
        'manage': (context) => const Manage(),
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
