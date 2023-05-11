import 'package:shared_preferences/shared_preferences.dart';

// helper class for data
class SharedPrefHelper {
  // retrieve user id
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // retrieve user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // retrieve user township
  static Future<String?> getUserTownship() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userTsp');
  }

  // retrieve user village
  static Future<String?> getUserVillage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userVil');
  }

  // retrieve is other village
  static Future<bool?> getIsOtherVillage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isOtherVillage');
  }

  // retrieve user warehouse
  static Future<String?> getUserWarehouse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userWarehouse');
  }

  // retrieve is other warehouse
  static Future<bool?> getIsOtherWarehouse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isOtherWarehouse');
  }
}
