import 'dart:convert';
import 'package:chdn_pharmacy/screens/restore_user_id.dart';
import 'package:chdn_pharmacy/widgets/buildinventorycontent.dart';
import 'package:http/http.dart' as http;
import 'package:chdn_pharmacy/screens/group_dispense.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../database/database_helper.dart';
import '../database/shared_pref_helper.dart';
import '../database/synchronize.dart';
import '../widgets/nav_bar.dart';
import 'add_stock.dart';
import 'item_inventory.dart';
import 'scan_preview.dart';
import 'update_profile.dart';

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

  // to store QR scanned data
  String? jsonString;
  List<Map<String, dynamic>> scannedList = [];

  // to sync
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> itemTypeData = [];
  List<Map<String, dynamic>> itemData = [];
  List<Map<String, dynamic>> packageFormData = [];
  List<Map<String, dynamic>> sourcePlaceData = [];
  List<Map<String, dynamic>> donorData = [];
  List<Map<String, dynamic>> destinationData = [];
  final SynchronizationData synchronizationData = SynchronizationData();

  // to show or hide sync button
  bool showBtnSync = false;
  // to save user data to server
  String userName = '';
  String userTownship = '';
  String userVillage = '';
  String userWarehouse = '';
  String userId = '';
  bool isOtherVillage = false;
  bool isOtherWarehouse = false;

  @override
  void initState() {
    super.initState();
    SharedPrefHelper.getUserId().then((value) {
      if (value == null || value.isEmpty || value == '') {
        setState(() {
          showBtnSync = false;
        });
      } else {
        setState(() {
          showBtnSync = true;
        });
      }
    });
    SharedPrefHelper.getUserName().then((value) {
      setState(() {
        userName = value ?? '';
      });
    });
    SharedPrefHelper.getUserTownship().then((value) {
      setState(() {
        userTownship = value ?? '';
      });
    });
    SharedPrefHelper.getUserVillage().then((value) {
      setState(() {
        userVillage = value ?? '';
      });
    });
    SharedPrefHelper.getUserWarehouse().then((value) {
      setState(() {
        userWarehouse = value ?? '';
      });
    });
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        userId = value ?? '';
      });
    });
    SharedPrefHelper.getIsOtherVillage().then((value) {
      setState(() {
        isOtherVillage = value ?? false;
      });
    });
    SharedPrefHelper.getIsOtherWarehouse().then((value) {
      setState(() {
        isOtherWarehouse = value ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('CHDNventory'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ), // end of app bar
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sizedBoxH20(),
              FutureBuilder<String?>(
                  // check profile set up
                  future: SharedPrefHelper.getUserId(), //check user id
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      // return check inventory if user id present
                      return BuildInventoryContent();
                    } else {
                      // return this if user id absent
                      return buildProfileSetup();
                    }
                  })
            ])),
      ),
      // start of add stock fab
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // start of dipsense fab
          if (showBtnSync) buildDispenseButton(),
          // end of dispense fab
          sizedBoxW10(),
          if (showBtnSync) buildAddStockButton(),
          // start of sync button
          if (showBtnSync) sizedBoxW10(),
          if (showBtnSync) buildSyncButton(),
          // end of sync button
        ],
      ),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }

  Widget buildProfileSetup() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.6,
      margin: EdgeInsets.only(
          top: 20,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: const Color.fromARGB(255, 218, 218, 218), width: 1),
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
              'You have not set your Warehouse/Clinic profile.\nPlease click `Update Profile` button.\nဆေးဂိုဒေါင်/ဆေးခန်းဆိုင်ရာ အချက်အလက်များ မဖြည့်သွင်းရသေးပါ။\nအသစ်စတင်အသုံးပြုသူဖြစ်လျှင် `Update Profile` ခလုတ်ကိုနှိပ်၍ဖြည့်သွင်းပါ\nယခင်အသုံးပြုဖူးသူဖြစ်လျှင် အချက်အလက်များပြန်လည်ရယူရန် `Restore with User ID` ကိုနှိပ်ပါ'),
          SizedBox(
            // Start of update profile button
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
              label: const Text('Update Profile',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.background),
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
            ),
          ),
          sizedBoxH10(),
          reusableHotButton(Icons.restore_page_outlined, 'Restore with User ID',
              () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RestoreUserId()));
            if (result == 'success') {
              setState(() {});
            }
          })
        ],
      ),
    );
  }

  Future<void> scanQrCode() async {
    String scanResponse;
    try {
      scanResponse = await FlutterBarcodeScanner.scanBarcode(
          '#d2d2d2', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      scanResponse = 'Failed to get Platform Version.';
    }
    if (!mounted) return;
    setState(() {
      jsonString = scanResponse;
      scannedList =
          List<Map<String, dynamic>>.from(jsonDecode(jsonString ?? ''));
    });
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScanPreview(
                  previewList: scannedList,
                )));
    if (result == 'success') {
      setState(() {});
    }
  }

  Future<void> sendUserData() async {
    Map<String, dynamic> userData = {
      'device_user_name': userName,
      'device_user_township': userTownship,
      'device_user_village': userVillage,
      'device_user_warehouse': userWarehouse,
      'device_user_id': userId,
      'device_is_other_village': isOtherVillage.toString(),
      'device_is_other_warehouse': isOtherWarehouse.toString()
    };
    String userDataJson = SynchronizationData().prepareUserDataForApi(userData);
    http.Response response =
        await SynchronizationData().uploadUserDataToApi(userDataJson);
    print(userDataJson);
    SynchronizationData().handleResponse(response);
  }

  Widget buildDispenseButton() {
    return FloatingActionButton.extended(
      heroTag: 'btnDispense',
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GroupDispense()));
        if (result == 'success') {
          setState(() {});
        }
      },
      label: const Text(
        'Dispense',
        style: TextStyle(
            color: Color.fromARGB(255, 49, 49, 49),
            fontWeight: FontWeight.bold),
      ),
      icon: const Icon(
        Icons.outbond_outlined,
        color: Color.fromARGB(255, 49, 49, 49),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 197, 63),
    );
  }

  Widget buildAddStockButton() {
    return SpeedDial(
      buttonSize: const Size(48, 48),
      label: const Text(
        'Add Stock',
        style: TextStyle(
            color: Color.fromARGB(255, 49, 49, 49),
            fontWeight: FontWeight.bold),
      ),
      animatedIcon: AnimatedIcons.list_view,
      animatedIconTheme:
          const IconThemeData(color: Color.fromARGB(255, 49, 49, 49)),
      backgroundColor: const Color.fromARGB(255, 255, 197, 63),
      spacing: 20,
      spaceBetweenChildren: 10,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.keyboard_outlined),
          label: 'တစ်ခုချင်း',
          backgroundColor: const Color.fromARGB(255, 255, 227, 160),
          onTap: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddStock()));
            if (result == 'success') {
              setState(() {});
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.qr_code_2_outlined),
          label: 'QR ဖြင့်',
          backgroundColor: const Color.fromARGB(255, 255, 227, 160),
          onTap: () async {
            await scanQrCode();
          },
        ),
      ],
    );
  }

  Widget buildSyncButton() {
    return FloatingActionButton(
      heroTag: 'btnSync',
      backgroundColor: Colors.green,
      onPressed: () async {
        if (await SynchronizationData.isInternet()) {
          DatabaseHelper().getAllStockForSync().then((value) {
            setState(() {
              data = value;
            });
          });
          DatabaseHelper().getAllItemTypeForSync().then((value) {
            setState(() {
              itemTypeData = value;
            });
          });
          DatabaseHelper().getAllItemForSync().then((value) {
            setState(() {
              itemData = value;
            });
          });
          DatabaseHelper().getAllPackageFormForSync().then((value) {
            setState(() {
              packageFormData = value;
            });
          });
          DatabaseHelper().getAllSourcePlaceForSync().then((value) {
            setState(() {
              sourcePlaceData = value;
            });
          });
          DatabaseHelper().getAllDonorForSync().then((value) {
            setState(() {
              donorData = value;
            });
          });
          DatabaseHelper().getAllDestinationForSync().then((value) {
            setState(() {
              destinationData = value;
            });
          });

          EasyLoading.showProgress(0.1, status: 'အချက်အလက်များပေးပို့နေပါသည်');
          // send stock data
          String dataJson = SynchronizationData().prepareDataForApi(data);
          try {
            http.Response response =
                await SynchronizationData().uploadDataToApi(dataJson);
            SynchronizationData().handleResponse(response);
          } catch (e) {
            EasyLoading.showError('$e');
          }
          // send item type data
          String itemTypeDataJson =
              SynchronizationData().prepareDataForApi(itemTypeData);
          try {
            http.Response response = await SynchronizationData()
                .uploadItemTypeDataToApi(itemTypeDataJson);
            SynchronizationData().handleResponse(response);
          } catch (e) {
            EasyLoading.showError('$e');
          }
          // send item data
          String itemDataJson =
              SynchronizationData().prepareDataForApi(itemData);
          try {
            http.Response response =
                await SynchronizationData().uploadItemDataToApi(itemDataJson);
            SynchronizationData().handleResponse(response);
          } catch (e) {
            EasyLoading.showError('$e');
          }
          // send package form data
          String packageFormDataJson =
              SynchronizationData().prepareDataForApi(packageFormData);
          try {
            http.Response response = await SynchronizationData()
                .uploadPackageFormDataToApi(packageFormDataJson);
            SynchronizationData().handleResponse(response);
          } catch (e) {
            EasyLoading.showError('$e');
          }
          // send source place data
          String sourcePlaceDataJson =
              SynchronizationData().prepareDataForApi(sourcePlaceData);
          try {
            http.Response response = await SynchronizationData()
                .uploadSourcePlaceDataToApi(sourcePlaceDataJson);
            SynchronizationData().handleResponse(response);
          } catch (e) {
            EasyLoading.showError('$e');
          }
          // send donor data
          String donorDataJson =
              SynchronizationData().prepareDataForApi(donorData);
          try {
            http.Response response =
                await SynchronizationData().uploadDonorDataToApi(donorDataJson);
            SynchronizationData().handleResponse(response);
          } catch (e) {
            EasyLoading.showError('$e');
          }
          // send destination data
          String destinationDataJson =
              SynchronizationData().prepareDataForApi(destinationData);
          try {
            http.Response response = await SynchronizationData()
                .uploadDestinationDataToApi(destinationDataJson);
            SynchronizationData().handleResponse(response);
          } catch (e) {
            EasyLoading.showError('$e');
          }
          // send user data
          sendUserData();
          EasyLoading.showSuccess('အချက်အလက်များ ပေးပို့ပြီးပါပြီ။');
        } else {
          EasyLoading.showError('No internet connection');
        }
      },
      child: const Icon(Icons.cloud_upload_outlined),
    );
  }
}
