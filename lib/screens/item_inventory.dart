import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:flutter/material.dart';

class ItemInventory extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String itemType;
  const ItemInventory(
      {super.key,
      required this.itemId,
      required this.itemName,
      required this.itemType});

  @override
  State<ItemInventory> createState() => _ItemInventoryState();
}

class _ItemInventoryState extends State<ItemInventory> {
  int? totalBalance;

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getTotalBalance(widget.itemId).then((value) {
      setState(() {
        totalBalance = value!['total_balance'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('${widget.itemName}, ${widget.itemType}'),
        centerTitle: true,
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
            // start of _specify_ card
            Card(
              elevation: 5,
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.medication),
                title: Text(widget.itemName),
                subtitle: Text(widget.itemType),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(totalBalance.toString(),
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ), // end of _specify_ card
          ])),
    );
  }
}
