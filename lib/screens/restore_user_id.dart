import 'dart:convert';

import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestoreUserId extends StatefulWidget {
  const RestoreUserId({super.key});

  @override
  State<RestoreUserId> createState() => _RestoreUserIdState();
}

class _RestoreUserIdState extends State<RestoreUserId> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // controller
  TextEditingController userIdController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Restore With User ID'),
        centerTitle: true,
      ), // end of app bar
      body: Form(
        key: _key,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sizedBoxH20(),
              buildInfoText(),
              sizedBoxH20(),
              buildUserIdLabelText(),
              sizedBoxH10(),
              buildUserIdTextFormField(),
              sizedBoxH20(),
              reusableHotButton(Icons.restore_page_outlined, 'Restore',
                  () async {
                if (_key.currentState != null &&
                    _key.currentState!.validate()) {
                  _key.currentState!.save();
                  try {
                    await restoreUserData();
                    await restoreStockData();
                    await restoreItemTypeData();
                    await restoreItemData();
                    await restorePackageFormData();
                    await restoreSourcePlaceData();
                    await restoreDonorData();
                    await restoreDestinationData();
                    Navigator.pop(context, 'success');
                  } catch (e) {
                    EasyLoading.showError('$e');
                  }
                } else {
                  EasyLoading.showError('Please enter User ID!');
                }
              })
            ])),
      ),
    );
  }

  Widget buildInfoText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline),
        sizedBoxW10(),
        const Expanded(
          child: Text(
              'အချက်အလက်ပေးပို့ထားဖူးသူများအနေနှင့် မိမိ User ID ကိုပြန်လည်ထည့်သွင်းပြီး အချက်အလက်များပြန်လည်ရယူနိုင်ပါသည်။ အချက်အလက်များပြန်လည်ရယူချိန်တွင် အင်တာနက်ဆက်သွယ်မှုရှိရန်လိုအပ်ပါသည်။',
              style: TextStyle(fontSize: 10)),
        )
      ],
    );
  }

  Widget buildUserIdLabelText() {
    return const Text('User ID', style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildUserIdTextFormField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: userIdController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter user id';
          }
          return null;
        },
        onSaved: (value) {
          userIdController.text = value!;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: const Icon(
              Icons.badge_outlined,
              color: Colors.grey,
            ),
            hintText: 'Enter User ID',
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.background,
                    width: 2))),
        maxLines: 1,
      ),
    );
  }

  Future<Map<String, dynamic>> retrieveUserDataFromServer(String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_user_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve user data');
    }
  }

  Future<void> restoreUserData() async {
    EasyLoading.showProgress(0.1, status: 'အချက်အလက်များရယူနေပါသည်');
    try {
      final userData = await retrieveUserDataFromServer(userIdController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userData['device_user_id']);
      await prefs.setString('userName', userData['device_user_name']);
      await prefs.setString('userTownship', userData['device_user_township']);
      await prefs.setString('userVillage', userData['device_user_village']);
      await prefs.setString('userWarehouse', userData['device_user_warehouse']);
      await prefs.setBool(
          'isOtherVillage', userData['device_is_other_village'] == 'true');
      await prefs.setBool(
          'isOtherWarehouse', userData['device_is_other_warehouse'] == 'true');
      EasyLoading.showSuccess('အသုံးပြုသူအချက်အလက်များ ရယူပြီးပါပြီ');
    } catch (e) {
      print('User Data Error:$e');
      EasyLoading.showError(
          'အသုံးပြုသူအချက်အလက်များ ရှာမတွေ့ပါ။ User ID ကို နောက်တစ်ကြိမ်ပြန်လည်စစ်ဆေးပါ။',
          duration: const Duration(seconds: 5));
    }
  }

  Future<List<Map<String, dynamic>>> retrieveStockDataFromServer(
      String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_stock_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List<dynamic>) {
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid stock data format');
      }
    } else {
      throw Exception('Failed to retrieve stock data');
    }
  }

  Future<List<Map<String, dynamic>>> retrieveItemTypeDataFromServer(
      String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_item_type_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List<dynamic>) {
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid item type data format');
      }
    } else {
      throw Exception('Failed to retrieve item type data');
    }
  }

  Future<List<Map<String, dynamic>>> retrieveItemDataFromServer(
      String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_item_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List<dynamic>) {
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid item data format');
      }
    } else {
      throw Exception('Failed to retrieve item data');
    }
  }

  Future<List<Map<String, dynamic>>> retrievePackageFormDataFromServer(
      String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_package_form_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List<dynamic>) {
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid package form data format');
      }
    } else {
      throw Exception('Failed to retrieve package form data');
    }
  }

  Future<List<Map<String, dynamic>>> retrieveSourcePlaceDataFromServer(
      String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_source_place_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List<dynamic>) {
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid source place data format');
      }
    } else {
      throw Exception('Failed to retrieve source place data');
    }
  }

  Future<List<Map<String, dynamic>>> retrieveDonorDataFromServer(
      String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_donor_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List<dynamic>) {
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid donor data format');
      }
    } else {
      throw Exception('Failed to retrieve donor data');
    }
  }

  Future<List<Map<String, dynamic>>> retrieveDestinationDataFromServer(
      String userId) async {
    final response = await http.get(Uri.parse(
        'https://chdn-karenni.org/pharmacy/retrieve_destination_data.php?device_user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List<dynamic>) {
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid destination data format');
      }
    } else {
      throw Exception('Failed to retrieve destination data');
    }
  }

  Future<void> restoreStockData() async {
    try {
      final stockData =
          await retrieveStockDataFromServer(userIdController.text);
      await DatabaseHelper().restoreStockTable(stockData);
      EasyLoading.showSuccess('ပစ္စည်းအဝင်အထွက်မှတ်တမ်းများရယူပြီးပါပြီ။');
    } catch (e) {
      print('$e');
      EasyLoading.showError('ပစ္စည်းအဝင်အထွက်မှတ်တမ်းများ ရှာမတွေ့ပါ။');
    }
  }

  Future<void> restoreItemTypeData() async {
    try {
      final itemTypeData =
          await retrieveItemTypeDataFromServer(userIdController.text);
      await DatabaseHelper().restoreItemTypeTable(itemTypeData);
      EasyLoading.showSuccess('ပစ္စည်းအမျိုးအစားမှတ်တမ်းများရယူပြီးပါပြီ။');
    } catch (e) {
      print('$e');
      EasyLoading.showError('ပစ္စည်းအမျိုးအစားမှတ်တမ်းများ ရှာမတွေ့ပါ။');
    }
  }

  Future<void> restoreItemData() async {
    try {
      final itemData = await retrieveItemDataFromServer(userIdController.text);
      await DatabaseHelper().restoreItemTable(itemData);
      EasyLoading.showSuccess('ပစ္စည်းအမည်မှတ်တမ်းများရယူပြီးပါပြီ။');
    } catch (e) {
      print('$e');
      EasyLoading.showError('ပစ္စည်းအမည်မှတ်တမ်းများ ရှာမတွေ့ပါ။');
    }
  }

  Future<void> restorePackageFormData() async {
    try {
      final packageFormData =
          await retrievePackageFormDataFromServer(userIdController.text);
      await DatabaseHelper().restorePackageFormTable(packageFormData);
      EasyLoading.showSuccess('ထုပ်ပိုးပုံစံမှတ်တမ်းများရယူပြီးပါပြီ။');
    } catch (e) {
      print('$e');
      EasyLoading.showError('ထုတ်ပိုးပုံစံမှတ်တမ်းများ ရှာမတွေ့ပါ။');
    }
  }

  Future<void> restoreSourcePlaceData() async {
    try {
      final sourcePlaceData =
          await retrieveSourcePlaceDataFromServer(userIdController.text);
      await DatabaseHelper().restoreSourcePlaceTable(sourcePlaceData);
      EasyLoading.showSuccess('ရရှိရာနေရာမှတ်တမ်းများရယူပြီးပါပြီ။');
    } catch (e) {
      print('$e');
      EasyLoading.showError('ရရှိရာနေရာမှတ်တမ်းများ ရှာမတွေ့ပါ။');
    }
  }

  Future<void> restoreDonorData() async {
    try {
      final donorData =
          await retrieveDonorDataFromServer(userIdController.text);
      await DatabaseHelper().restoreDonorTable(donorData);
      EasyLoading.showSuccess('အလှူရှင်မှတ်တမ်းများရယူပြီးပါပြီ။');
    } catch (e) {
      print('$e');
      EasyLoading.showError('အလှူရှင်မှတ်တမ်းများ ရှာမတွေ့ပါ။');
    }
  }

  Future<void> restoreDestinationData() async {
    try {
      final destinationData =
          await retrieveDestinationDataFromServer(userIdController.text);
      await DatabaseHelper().restoreDestinationTable(destinationData);
      EasyLoading.showSuccess('ပေးပို့ရာနေရာမှတ်တမ်းများရယူပြီးပါပြီ။');
    } catch (e) {
      print('$e');
      EasyLoading.showError('ပေးပို့ရာနေရာမှတ်တမ်းများ ရှာမတွေ့ပါ။');
    }
  }
}
