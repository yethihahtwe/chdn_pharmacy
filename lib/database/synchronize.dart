import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SynchronizationData {
  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await InternetConnectionChecker().hasConnection) {
        return true;
      } else {
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await InternetConnectionChecker().hasConnection) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // prepare sqlite data for api
  String prepareDataForApi(List<Map<String, dynamic>> value) {
    return jsonEncode({'value': value});
  }

  // prepare shared preferences data for api
  String prepareUserDataForApi(Map<String, dynamic> value) {
    return jsonEncode({'userData': value});
  }

  // api end point to upload stock data
  Future<http.Response> uploadDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/sqflite-sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  // api end point to upload item type
  Future<http.Response> uploadItemTypeDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/item_type_sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  // api end point to upload item
  Future<http.Response> uploadItemDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/item_sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  // api end point to upload package form
  Future<http.Response> uploadPackageFormDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/package_form_sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  // api end point to upload source place
  Future<http.Response> uploadSourcePlaceDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/source_place_sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  // api end point to upload item
  Future<http.Response> uploadDonorDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/donor_sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  // api end point to upload item
  Future<http.Response> uploadDestinationDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/destination_sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  // api end point to upload user data
  Future<http.Response> uploadUserDataToApi(String value) async {
    http.Client client = http.Client();
    http.Response response = await client.post(
        Uri.parse('https://chdn-karenni.org/pharmacy/user_data_sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: value);
    client.close();
    return response;
  }

  Future<void> handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Upload successful');
      print(response.body);
    } else {
      print('Upload failed');
      print(response.body);
    }
  }
}
