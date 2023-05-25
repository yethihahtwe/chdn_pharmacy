import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:chdn_pharmacy/screens/reusable_widget.dart';
import 'package:flutter/material.dart';

import 'reusable_function.dart';

class StockDetail extends StatefulWidget {
  final int stockId;
  final String itemName;
  final String itemType;
  final String packageForm;

  const StockDetail(
      {super.key,
      required this.stockId,
      required this.itemName,
      required this.itemType,
      required this.packageForm});

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  // empty string map to load stock detail
  Map<String, dynamic> _stockDetail = {};

  @override
  void initState() {
    super.initState();
    // assign query result to string map
    DatabaseHelper().getStockById(widget.stockId).then((value) {
      setState(() {
        _stockDetail = value ?? {};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.itemName),
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
            // start of date row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Date:')),
                Expanded(
                  flex: 1,
                  child: Text(
                    _stockDetail['stock_date'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: _stockDetail['stock_type'] == 'IN'
                      ? IconButton(
                          iconSize: 16,
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditStockDate(
                                          dateType: 'Date',
                                          dateValue: _stockDetail['stock_date'],
                                          stockId: widget.stockId,
                                          columnName: 'stock_date',
                                          idColumn: 'stock_id',
                                          tableName: 'tbl_stock',
                                        )));
                            if (result == 'success') {
                              DatabaseHelper()
                                  .getStockById(widget.stockId)
                                  .then((value) {
                                setState(() {
                                  _stockDetail = value ?? {};
                                });
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                        )
                      : null,
                )
              ],
            ), // end of date row
            const Divider(),
            // start of stock type row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Stock Type:')),
                Expanded(
                  flex: 1,
                  child: Text(
                    _stockDetail['stock_type'] == 'IN'
                        ? 'Stock-in'
                        : _stockDetail['stock_type'] == 'OUT'
                            ? 'Stock-out'
                            : _stockDetail['stock_type'] == 'EXP'
                                ? 'Expired'
                                : _stockDetail['stock_type'] == 'DMG'
                                    ? 'Damaged'
                                    : '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ), // end of stock type row
            const Divider(),
            // start of item name row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Item:')),
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.itemName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ), // end of item name row
            const Divider(),
            // start of item type row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Item Type:')),
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.itemType,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ), // end of item type row
            const Divider(),
            // start of exp date row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Expiry Date:')),
                Expanded(
                    flex: 1,
                    child: Text(
                        _stockDetail['stock_exp_date'] == null
                            ? 'No expiry date'
                            : _stockDetail['stock_exp_date'] == ''
                                ? 'No expiry date'
                                : _stockDetail['stock_exp_date'],
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: _stockDetail['stock_type'] == 'IN'
                      ? IconButton(
                          iconSize: 16,
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditStockDate(
                                        dateType: 'Expiray Date',
                                        dateValue:
                                            _stockDetail['stock_exp_date'],
                                        stockId: widget.stockId,
                                        tableName: 'tbl_stock',
                                        columnName: 'stock_exp_date',
                                        idColumn: 'stock_id')));
                            if (result == 'success') {
                              DatabaseHelper()
                                  .getStockById(widget.stockId)
                                  .then((value) {
                                setState(() {
                                  _stockDetail = value ?? {};
                                });
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                        )
                      : null,
                )
              ],
            ), // end of exp date row
            const Divider(),
            // start of batch number row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Batch Number:')),
                Expanded(
                    flex: 1,
                    child: Text(
                        _stockDetail['stock_batch'] == null
                            ? 'No batch number'
                            : _stockDetail['stock_batch'] == ''
                                ? 'No batch number'
                                : _stockDetail['stock_batch'],
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: _stockDetail['stock_type'] == 'IN'
                      ? IconButton(
                          iconSize: 16,
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditStockNonDate(
                                          fieldNameToEdit: 'Batch Number',
                                          iconName: Icons.more_outlined,
                                          queryValue:
                                              _stockDetail['stock_batch'],
                                          columnName: 'stock_batch',
                                          id: widget.stockId,
                                          isNumberKeyboard: false,
                                        )));
                            if (result == 'success') {
                              DatabaseHelper()
                                  .getStockById(widget.stockId)
                                  .then((value) {
                                setState(() {
                                  _stockDetail = value ?? {};
                                });
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                        )
                      : null,
                )
              ],
            ), // end of batch number row
            const Divider(),
            // start of amount row
            Row(children: [
              const Expanded(flex: 1, child: Text('Stock Amount:')),
              Expanded(
                  flex: 1,
                  child: Text(
                    _stockDetail['stock_amount'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                width: 30,
                height: 30,
                child: _stockDetail['stock_type'] == 'IN'
                    ? IconButton(
                        iconSize: 16,
                        onPressed: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditStockNonDate(
                                        fieldNameToEdit: 'Stock Amount',
                                        iconName: Icons.format_list_numbered,
                                        queryValue:
                                            _stockDetail['stock_amount'],
                                        columnName: 'stock_amount',
                                        id: widget.stockId,
                                        isNumberKeyboard: true,
                                      )));
                          if (result == 'success') {
                            DatabaseHelper()
                                .getStockById(widget.stockId)
                                .then((value) {
                              _stockDetail = value ?? {};
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                      )
                    : null,
              )
            ]), // end of amount row
            const Divider(),
            // start of package form row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Package Form:')),
                Expanded(
                    flex: 1,
                    child: Text(widget.packageForm,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: _stockDetail['stock_type'] == 'IN'
                      ? IconButton(
                          iconSize: 16,
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditStockDropdown(
                                          dropdownTableName: 'tbl_package_form',
                                          dropdownIdColumn: 'package_form_id',
                                          dropdownNameColumn:
                                              'package_form_name',
                                          fieldNameToEdit: 'Package Form',
                                          queryValue: _stockDetail[
                                              'stock_package_form_id'],
                                          iconName: Icons.inventory_2,
                                          columnName: 'stock_package_form_id',
                                          stockId: widget.stockId,
                                        )));
                            if (result == 'success') {
                              DatabaseHelper()
                                  .getStockById(widget.stockId)
                                  .then((value) {
                                _stockDetail = value ?? {};
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                        )
                      : null,
                )
              ],
            ), // end of package form row
            const Divider(),
            // start of source place row
            Row(
              children: [
                const Expanded(
                    flex: 1,
                    child: Text(
                      'Source Place:',
                    )),
                Expanded(
                    flex: 1,
                    child: Text(_stockDetail['source_place'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: _stockDetail['stock_type'] == 'IN'
                      ? IconButton(
                          iconSize: 16,
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        )
                      : null,
                )
              ],
            ), // end of source place row
            const Divider(),
            // start of donor row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Donor:')),
                Expanded(
                    flex: 1,
                    child: Text(_stockDetail['donor'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: _stockDetail['stock_type'] == 'IN'
                      ? IconButton(
                          iconSize: 16,
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        )
                      : null,
                )
              ],
            ), // end of donor row
            const Divider(),
            // start of remark row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Remark:')),
                Expanded(
                  flex: 1,
                  child: Text(_stockDetail['stock_remark'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: _stockDetail['stock_type'] == 'IN'
                      ? IconButton(
                          iconSize: 16,
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        )
                      : null,
                )
              ],
            ), // end of remark row
            const Divider(),
            // start of sync row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('Sync status:')),
                Expanded(
                    flex: 1,
                    child: Text(
                        _stockDetail['stock_sync'] == null
                            ? 'Not synced'
                            : _stockDetail['stock_sync'] == ''
                                ? 'Not synced'
                                : _stockDetail['stock_sync'],
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(
                  width: 30,
                )
              ],
            ), // end of sync row
            const SizedBox(
              height: 20,
            ),
            // start of button row
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Go Back',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.background),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                      ),
                    )),
                const Expanded(flex: 1, child: SizedBox(width: 10)),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                      width: 200,
                      height: 45,
                      child: TextButton(
                          onPressed: () {
                            _deleteStock();
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.red, width: 2)),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ))),
                )
              ],
            )
          ])),
    );
  }

  void _deleteStock() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Delete?'),
              content: const Text(
                'ပစ္စည်းမှတ်တမ်းကိုဖျက်ပစ်ရန် သေချာပါသလား?',
                style: TextStyle(fontSize: 12),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      await DatabaseHelper().deleteStock(widget.stockId);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, 'success');
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ]);
        });
  }
}
