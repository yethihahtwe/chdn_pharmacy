import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  // Index for bottom navigation bar
  int _selectedIndex = 4;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Information'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ), // end of app bar
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            // start of logo row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: // start of chdn logo
                      Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 218, 218, 218),
                            width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(94, 158, 158, 158),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5.0)),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/CHDN_LOGO.png'),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox(width: 10)),
                // start of ehssg logo
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 218, 218, 218),
                            width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(94, 158, 158, 158),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5.0)),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset('assets/images/EHSSG_Logo2.png'),
                    ),
                  ),
                )
              ],
            ), // end of logo row
            const SizedBox(height: 20),
            const Center(
                child: Text(
              'CHDNventory',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            const Center(child: Text('v 1.0')),
            const Text('Release history',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              'v1.0 - released on 30-MAY-2023',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(style: TextStyle(fontSize: 12), 'The'),
                  Text(
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      'CHDN Pharmacy Inventory Management Mobile Application'),
                  Text(style: TextStyle(fontSize: 12), 'was developed for'),
                  Text(
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      'Civil Health and Development Network - Karenni'),
                  Text(style: TextStyle(fontSize: 12), 'by'),
                  Text(
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      'Ethnic Health Systems Strengthening Group.'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
                style: TextStyle(fontSize: 12),
                'အင်တာနက်ဆက်သွယ်မှုမရရှိသည့်နေရာများတွင် အချက်အလက်များမှတ်တမ်းတင်သိမ်းဆည်းနိုင်ရန် ရည်ရွယ်ပါသည်။ အသုံးပြုသည့်ဖုန်း/တက်ဘလက်အတွင်း၌သာ အချက်အလက်များသိမ်းဆည်းထားသောကြောင့် အပလီကေးရှင်းကိုမဖျက်ခင် (သို့) စက်ပစ္စည်းပျက်စီးခြင်းမဖြစ်ပေါ်ခင် မိခင်အဖွဲ့အစည်းထံသို့ အင်တာနက်ရချိန်၌ အချက်အလက်များပေးပို့ထားရန်လိုပါသည်။')
          ])),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
