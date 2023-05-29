import 'package:chdn_pharmacy/database/database_helper.dart';
import 'package:flutter/material.dart';

import '../model/data_model.dart';

class EditStock {
  static Future<void> saveStockData(String tableName, String columnName,
      String idColumn, var value, int id) async {
    await DatabaseHelper()
        .updateSingleValue(tableName, columnName, idColumn, value, id);
  }

  static Future<void> insertStockData(
      String stockDate,
      String stockType,
      int stockItemId,
      int stockPackageFormId,
      String stockExpDate,
      String stockBatch,
      int stockAmount,
      int stockSourcePlaceId,
      int stockDonorId,
      String? stockRemark,
      int? stockTo,
      String? stockSync,
      String stockCre,
      String stockDraft) async {
    await DatabaseHelper().insertStock(Stock.insertStock(
        stockDate: stockDate,
        stockType: stockType,
        stockItemId: stockItemId,
        stockPackageFormId: stockPackageFormId,
        stockExpDate: stockExpDate,
        stockBatch: stockBatch,
        stockAmount: stockAmount,
        stockSourcePlaceId: stockSourcePlaceId,
        stockDonorId: stockDonorId,
        stockRemark: stockRemark ?? '',
        stockTo: stockTo ?? 0,
        stockSync: stockSync ?? '',
        stockCre: stockCre,
        stockDraft: stockDraft));
  }
}

class FormControl {
  static Future<void> alertDialog(
      BuildContext context, String requiredValue) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$requiredValue !'),
            content: Text(
              'please enter $requiredValue.',
              style: const TextStyle(fontSize: 12),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text('OK',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white))),
            ],
          );
        });
  }
}
