import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
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
                        boxShadow: [
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
                Expanded(flex: 1, child: const SizedBox(width: 10)),
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
                        boxShadow: [
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
            Center(
                child: Text(
              'CHDNventory',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            Center(child: Text('v 1.0')),
            const Text('Release history',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              'v1.0 - released on 30-MAY-2023',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                  TextSpan(text: 'The '),
                  TextSpan(
                      text:
                          'CHDN Pharmacy Inventory Management Mobile Application',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' was developed for '),
                  TextSpan(
                      text: 'Civil Health and Development Network - Karenni',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ])),
            const Text('')
          ])),
    );
  }
}
