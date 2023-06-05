import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/database/shared_pref_helper.dart';
import 'package:chdn_pharmacy/model/data_model.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ScanPreview extends StatefulWidget {
  final List<Map<String, dynamic>> previewList;
  const ScanPreview({super.key, required this.previewList});

  @override
  State<ScanPreview> createState() => _ScanPreviewState();
}

class _ScanPreviewState extends State<ScanPreview> {
  // form key
  final GlobalKey<FormState> _key = GlobalKey();

  // pick date
  DateTime? date;
  bool isDatePicked = false;
  String getDateText() {
    if (date == null) {
      setState(() {
        isDatePicked = false;
      });
      return 'Select Date';
    } else {
      setState(() {
        isDatePicked = true;
      });
      String day = date!.day.toString().padLeft(2, '0');
      String month = date!.month.toString().padLeft(2, '0');
      String year = date!.year.toString();
      return '$year-$month-$day';
    }
  }

  // selected value
  int? selectedSourcePlace;
// dropdown options
  List<SourcePlaceMenu> sourcePlaceList = [];

  // user id
  String? userId;

  @override
  void initState() {
    super.initState();
    // Load select * result to List<String>
    DatabaseHelper().getAllSourcePlace().then((value) {
      setState(() {
        sourcePlaceList = value
            .map((e) => SourcePlaceMenu(
                  e['source_place_id'] as int,
                  e['source_place_name'].toString(),
                ))
            .toList();
      });
    });
    SharedPrefHelper.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Preview Import'),
        centerTitle: true,
      ),
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
              sizedBoxH10(),
              buildDatePicker(),
              sizedBoxH10(),
              buildSourcePlaceDropdown(),
              sizedBoxH10(),
              buildPreviewList(),
              sizedBoxH10(),
              reusableTwoButtonRow(
                  reusableHotButton(Icons.exit_to_app_outlined, 'Save',
                      () async {
                    if (date == null) {
                      EasyLoading.showError(
                          'Please select Date\nရက်စွဲရွေးခြယ်ပါ');
                    } else if (selectedSourcePlace == null) {
                      EasyLoading.showError(
                          'Please select Source Place\nလက်ခံရရှိရာနေရာ ရွေးခြယ်ပါ');
                    } else {
                      await DatabaseHelper().importQrToStock(
                          widget.previewList,
                          getDateText(),
                          selectedSourcePlace ?? 0,
                          userId ?? '');
                      Navigator.pop(context, 'success');
                    }
                  }),
                  reusableColdButton('Cancel', () async {
                    Navigator.pop(context);
                  }))
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
              'QR code မှဖတ်ရှုထားသည့် ပစ္စည်းစာရင်းဖြစ်ပါသည်။ မိမိပစ္စည်းစာရင်းတွင်မရှိသေးသည့် အမျိုးအမည်များ QR code တွင်ပါဝင်လာပါက ပစ္စည်းအမည်လွဲမှားခြင်း၊ ပစ္စည်းအမည်မပါဝင်ခြင်းတို့ဖြစ်ပေါ်တတ်ပါသည်။ လက်ဝယ်ရရှိသည့်ပစ္စည်းများနှင့် QR မှဖတ်ရှုထားသည့်စာရင်းကို တိုက်ဆိုင်စစ်ဆေးရန်လိုပါသည်။',
              style: TextStyle(fontSize: 12)),
        )
      ],
    );
  }

  DropdownMenuItem<int> buildSourcePlaceListMenuItem(SourcePlaceMenu item) =>
      DropdownMenuItem(
          value: item.id,
          child: Text(
            item.name,
            style: const TextStyle(fontSize: 15),
          ));

  Widget buildSourcePlaceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Source Place | လက်ခံရရှိရာနေရာ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<int>(
            icon: const Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: Colors.grey,
            ),
            value: selectedSourcePlace,
            validator: (value) {
              if (value == null) {
                return 'Please select source place';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.business_outlined,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 197, 63), width: 2)),
              contentPadding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
            ),
            hint: const Text('Select source place'),
            items: sourcePlaceList.map(buildSourcePlaceListMenuItem).toList(),
            onChanged: (value) => setState(() {
                  selectedSourcePlace = value;
                })),
      ],
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                      primary: Color.fromARGB(255, 218, 0, 76))),
              child: child!);
        });
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }

  Widget buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date (နှစ်-လ-ရက်)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        reusableHotButton(Icons.calendar_month_outlined, getDateText(),
            () async {
          await pickDate(context);
        })
      ],
    );
  }

  Widget buildPreviewListLabelText() {
    return const Text('Preview Items | လက်ခံရရှိသည့်ပစ္စည်းများ',
        style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildPreviewList() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      height: (MediaQuery.of(context).size.height) / 2,
      child: ListView.builder(
          itemCount: widget.previewList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = widget.previewList[index];
            return Column(
              children: [
                ListTile(
                  dense: true,
                  isThreeLine: true,
                  leading: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: Colors.blue,
                  ),
                  title: FutureBuilder<Map<String, dynamic>?>(
                      future: DatabaseHelper().getSingleValueReusable(
                          'tbl_item',
                          'item_name',
                          'item_id',
                          item['stock_item_id']),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                        if (snapshot.hasData) {
                          final map = snapshot.data!;
                          final itemName = map['item_name'] ?? '';
                          return Text(itemName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold));
                        }
                        return const Text('Item not found',
                            style: TextStyle(color: Colors.red));
                      }),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<Map<String, dynamic>?>(
                          future: DatabaseHelper().getSingleValueReusable(
                              'tbl_item',
                              'item_type',
                              'item_id',
                              item['stock_item_id']),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                            if (snapshot.hasData) {
                              final map = snapshot.data!;
                              final itemType = map['item_type'] ?? '';
                              return Text(itemType,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold));
                            }
                            return const Text('Item type not found',
                                style: TextStyle(color: Colors.red));
                          }),
                      Text('Exp(နှစ်-လ-ရက်): ${item['stock_exp_date']}')
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${item['stock_amount'] * -1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      FutureBuilder<Map<String, dynamic>?>(
                          future: DatabaseHelper().getSingleValueReusable(
                              'tbl_package_form',
                              'package_form_name',
                              'package_form_id',
                              item['stock_package_form_id']),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                            if (snapshot.hasData) {
                              final map = snapshot.data!;
                              final packageFormName =
                                  map['package_form_name'] ?? '';
                              return Text('$packageFormName(s)',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold));
                            }
                            return const Text('Package form not found',
                                style: TextStyle(color: Colors.red));
                          }),
                    ],
                  ),
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                )
              ],
            );
          }),
    );
  }
}
