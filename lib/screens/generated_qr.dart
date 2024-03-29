import 'dart:convert';
import 'dart:typed_data';
import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/home.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class GeneratedQR extends StatefulWidget {
  final int destinationId;
  final String stockDate;
  final String destinationName;
  final bool enableGoBack;
  const GeneratedQR({
    super.key,
    required this.destinationId,
    required this.stockDate,
    required this.destinationName,
    required this.enableGoBack,
  });

  @override
  State<GeneratedQR> createState() => _GeneratedQRState();
}

class _GeneratedQRState extends State<GeneratedQR> {
  // screenshot controller
  final screenshotController = ScreenshotController();

  // to show query result
  List<Map<String, dynamic>> settledList = [];

  // to store string converted json
  String? jsonData;

  @override
  void initState() {
    super.initState();
    DatabaseHelper()
        .getDispenseBatch(widget.destinationId, widget.stockDate)
        .then((value) {
      setState(() {
        settledList = value;
        jsonData = jsonEncode(settledList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Generate QR'),
        automaticallyImplyLeading: widget.enableGoBack,
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          return widget.enableGoBack;
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sizedBoxH20(),
              buildQrCode(),
              sizedBoxH10(),
              buildInfoText(),
              sizedBoxH20(),
              reusableTwoButtonRow(
                  reusableHotButton(Icons.save_alt_outlined, 'Save to gallery',
                      () async {
                    final image = await screenshotController.capture();
                    await saveImage(image!);
                    await EasyLoading.showSuccess('QR code သိမ်းဆည်းပြီးပါပြီ');
                    // ignore: use_build_context_synchronously
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  }),
                  reusableColdButton('Exit without save', () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  })),
              sizedBoxH10()
            ])),
      ),
    );
  }

  Widget buildTitleText() {
    return Text(
      '${widget.stockDate} တွင် ${widget.destinationName} သို့ ထုတ်ပေးသည့်ပစ္စည်းများ',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget buildInfoText() {
    return const Text(
        'ထုတ်ယူလိုက်သည့် ပစ္စည်းစာရင်းကို ဤ QR code တွင်ထည့်သွင်းထားပါသည်။ လက်ခံသည့်နေရာတွင် QR code ကို scan ပြုလုပ်ခြင်းဖြင့် ပစ္စည်းများအားလုံးလက်ခံထည့်သွင်းနိုင်ပါသည်။\nဤ QR ကို Manage စာမျက်နှာအောက်တွင်လည်း ထပ်မံရယူနိုင်ပါသည်။',
        style: TextStyle(
          fontSize: 10,
        ));
  }

  Widget buildQrCode() {
    return Center(
      child: Screenshot(
        controller: screenshotController,
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 2)),
            child: Column(
              children: [
                buildTitleText(),
                sizedBoxH20(),
                QrImageView(
                  backgroundColor: Colors.white,
                  data: jsonData ?? '',
                  version: QrVersions.auto,
                  size: 320,
                  gapless: true,
                ),
              ],
            )),
      ),
    );
  }

  Future<String> saveImage(Uint8List bytes) async {
    // ignore: await_only_futures
    await [Permission.photos.request()];
    final name = '${widget.stockDate}_${widget.destinationName}_QR';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }
}
