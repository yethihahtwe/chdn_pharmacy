import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/data_model.dart';

class DatabaseHelper {
  late Database _db;
  static const String tblItemType = 'tbl_item_type';
  static const String tblItem = 'tbl_item';
  static const String tblPackageForm = 'tbl_package_form';
  static const String tblSourcePlace = 'tbl_source_place';
  static const String tblDonor = 'tbl_donor';
  static const String tblDestination = 'tbl_destination';
  static const String tblStock = 'tbl_stock';

  DatabaseHelper() {
    _loadDatabase();
  }

// open database
  Future<Database> _loadDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pharmacy.db");
    _db = await openDatabase(path);
    return _db;
  }

  // database actions
  // item type table
  // insert
  Future<int> insertItemType(Map<String, dynamic> itemType) async {
    _db = await _loadDatabase();
    return await _db.insert(tblItemType, itemType);
  }

  // select *
  Future<List<Map<String, dynamic>>> getAllItemType() async {
    _db = await _loadDatabase();
    return await _db
        .rawQuery('SELECT * FROM $tblItemType ORDER BY item_type_id asc');
  }

  // update
  Future<int> updateItemType(Map<String, dynamic> itemType, int id) async {
    _db = await _loadDatabase();
    return await _db.update(tblItemType, itemType,
        where: "item_type_id=?", whereArgs: [id]);
  }

  // delete
  Future<int> deleteItemType(int id) async {
    _db = await _loadDatabase();
    return await _db
        .delete(tblItemType, where: "item_type_id=?", whereArgs: [id]);
  }

  // item table
  // insert
  Future<int> insertItem(Map<String, dynamic> item) async {
    _db = await _loadDatabase();
    return await _db.insert(tblItem, item);
  }

  // select *
  Future<List<Map<String, dynamic>>> getAllItem() async {
    _db = await _loadDatabase();
    return await _db.rawQuery('SELECT * FROM $tblItem ORDER BY item_id asc');
  }

  // select item filtered by item type
  Future<List<Map<String, dynamic>>> getAllItemByItemType(
      String itemType) async {
    _db = await _loadDatabase();
    return await _db
        .query(tblItem, where: "item_type=?", whereArgs: [itemType]);
  }

  // update
  Future<int> updateItem(Map<String, dynamic> item, int id) async {
    _db = await _loadDatabase();
    return await _db.update(tblItem, item, where: "item_id=?", whereArgs: [id]);
  }

  // delete
  Future<int> deleteItem(int id) async {
    _db = await _loadDatabase();
    return await _db.delete(tblItem, where: "item_id=?", whereArgs: [id]);
  }

  // check duplicate
  Future<int> itemDuplicateCount(
      String column1, String column2, String value1, String value2) async {
    _db = await _loadDatabase();
    final result = await _db.rawQuery(
        "SELECT COUNT(*) FROM $tblItem WHERE LOWER(REPLACE($column1, ' ', ''))=? AND LOWER(REPLACE($column2, ' ', ''))=?",
        [value1, value2]);
    await _db.close();
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // package form table
  // insert
  Future<int> insertPackageForm(Map<String, dynamic> packageForm) async {
    _db = await _loadDatabase();
    return await _db.insert(tblPackageForm, packageForm);
  }

  // select *
  Future<List<Map<String, dynamic>>> getAllPackageForm() async {
    _db = await _loadDatabase();
    return await _db
        .rawQuery('SELECT * FROM $tblPackageForm ORDER BY package_form_id asc');
  }

  // update
  Future<int> updatePackageForm(
      Map<String, dynamic> packageForm, int id) async {
    _db = await _loadDatabase();
    return await _db.update(tblPackageForm, packageForm,
        where: "package_form_id=?", whereArgs: [id]);
  }

  // delete
  Future<int> deletePackageForm(int id) async {
    _db = await _loadDatabase();
    return await _db
        .delete(tblPackageForm, where: "package_form_id=?", whereArgs: [id]);
  }

  // source place table
  // insert
  Future<int> insertSourcePlace(Map<String, dynamic> sourcePlace) async {
    _db = await _loadDatabase();
    return await _db.insert(tblSourcePlace, sourcePlace);
  }

  // select *
  Future<List<Map<String, dynamic>>> getAllSourcePlace() async {
    _db = await _loadDatabase();
    return await _db.rawQuery('SELECT * FROM $tblSourcePlace');
  }

  // update
  Future<int> updateSourcePlace(
      Map<String, dynamic> sourcePlace, int id) async {
    _db = await _loadDatabase();
    return await _db.update(tblSourcePlace, sourcePlace,
        where: "source_place_id=?", whereArgs: [id]);
  }

  // delete
  Future<int> deleteSourcePlace(int id) async {
    _db = await _loadDatabase();
    return await _db
        .delete(tblSourcePlace, where: "source_place_id=?", whereArgs: [id]);
  }

  // donor table
  // insert
  Future<int> insertDonor(Map<String, dynamic> donor) async {
    _db = await _loadDatabase();
    return await _db.insert(tblDonor, donor);
  }

  // select *
  Future<List<Map<String, dynamic>>> getAllDonor() async {
    _db = await _loadDatabase();
    return await _db.rawQuery('SELECT * FROM $tblDonor');
  }

  // update
  Future<int> updateDonor(Map<String, dynamic> donor, int id) async {
    _db = await _loadDatabase();
    return await _db
        .update(tblDonor, donor, where: "donor_id=?", whereArgs: [id]);
  }

  // delete
  Future<int> deleteDonor(int id) async {
    _db = await _loadDatabase();
    return await _db.delete(tblDonor, where: "donor_id=?", whereArgs: [id]);
  }

  // destination table
  // insert
  Future<int> insertDestination(Map<String, dynamic> destination) async {
    _db = await _loadDatabase();
    return await _db.insert(tblDestination, destination);
  }

  // select *
  Future<List<Map<String, dynamic>>> getAllDestination() async {
    _db = await _loadDatabase();
    return await _db.rawQuery('SELECT * FROM $tblDestination');
  }

  // update
  Future<int> updateDestination(
      Map<String, dynamic> destination, int id) async {
    _db = await _loadDatabase();
    return await _db.update(tblDestination, destination,
        where: "destination_id=?", whereArgs: [id]);
  }

  // update stock date
  Future<int> updateStockDate(String value, int id) async {
    _db = await _loadDatabase();
    return await _db.rawUpdate(
        'UPDATE $tblStock SET stock_date=? WHERE stock_id=?', [value, id]);
  }

  // delete
  Future<int> deleteDestination(int id) async {
    _db = await _loadDatabase();
    return await _db
        .delete(tblDestination, where: "destination_id=?", whereArgs: [id]);
  }

  // stock table
  // insert
  Future<int> insertStock(Map<String, dynamic> stock) async {
    _db = await _loadDatabase();
    return await _db.insert(tblStock, stock);
  }

  // delete
  Future<int> deleteStock(int id) async {
    _db = await _loadDatabase();
    return await _db.delete(tblStock, where: "stock_id=?", whereArgs: [id]);
  }

  // select for history screen
  Future<List<Map<String, dynamic>>> getAllStock() async {
    _db = await _loadDatabase();
    return await _db.rawQuery(
        "SELECT stock_id, stock_item_id, stock_date, stock_type, (SELECT item_name FROM $tblItem WHERE item_id=stock_item_id) AS item_name, (SELECT item_type FROM $tblItem WHERE item_id=stock_item_id) AS item_type, (SELECT package_form_name from $tblPackageForm WHERE package_form_id=stock_package_form_id) AS stock_package_form, stock_amount, stock_sync FROM tbl_stock");
  }

  // select single stock row for stock detail screen
  Future<Map<String, dynamic>?> getStockById(int id) async {
    _db = await _loadDatabase();
    List<Map<String, dynamic>> result = await _db.rawQuery(
        'SELECT stock_date, stock_type, stock_exp_date, stock_batch, stock_amount, stock_package_form_id, (SELECT package_form_name FROM tbl_package_form WHERE package_form_id=stock_package_form_id) AS package_form, (SELECT source_place_name FROM $tblSourcePlace WHERE source_place_id=stock_source_place_id) AS source_place, stock_source_place_id, (SELECT donor_name FROM $tblDonor WHERE donor_id=stock_donor_id) AS donor, stock_donor_id, stock_remark, (SELECT destination_name FROM $tblDestination WHERE destination_id=stock_to) AS destination, stock_to, stock_sync FROM $tblStock WHERE stock_id=$id');
    return result.isNotEmpty ? result.first : null;
  }

  // select group by for home screen
  Future<List<Map<String, dynamic>>> getAllBalance() async {
    _db = await _loadDatabase();
    return await _db.rawQuery(
        'SELECT stock_item_id, (SELECT item_name FROM $tblItem WHERE item_id=stock_item_id) AS item_name, (SELECT item_type FROM $tblItem WHERE item_id=stock_item_id) AS item_type, SUM(stock_amount) AS stock_amount FROM tbl_stock GROUP BY stock_item_id, item_name, item_type HAVING SUM(stock_amount) >0;');
  }

  // update single value
  Future<int> updateSingleValue(String tableName, String columnName,
      String idColumn, var value, int id) async {
    _db = await _loadDatabase();
    return await _db.rawUpdate(
        'UPDATE $tableName SET $columnName=? WHERE $idColumn=?', [value, id]);
  }

  // reusable get all
  Future<List<Map<String, dynamic>>> getAllReusable(String tableName) async {
    _db = await _loadDatabase();
    return await _db.query(tableName);
  }

  // item inventory screen
  // get total balance
  Future<Map<String, dynamic>?> getTotalBalance(itemId) async {
    _db = await _loadDatabase();
    List<Map<String, dynamic>> result = await _db.query(tblStock,
        columns: ['SUM(stock_amount) AS total_balance'],
        where: "stock_item_id=?",
        whereArgs: [itemId]);
    return result.isNotEmpty ? result.first : null;
  }

  // get balance by batch for item inventory screen
  Future<List<Map<String, dynamic>>> getBalanceByBatch(itemId) async {
    _db = await _loadDatabase();
    return await _db.query(tblStock,
        columns: [
          '(SELECT package_form_name FROM $tblPackageForm WHERE package_form_id=stock_package_form_id) AS package_form',
          'stock_package_form_id',
          'stock_exp_date',
          'stock_batch',
          'SUM(stock_amount)AS balance_by_batch',
          '(SELECT source_place_name from $tblSourcePlace WHERE source_place_id=stock_source_place_id) AS source_place',
          'stock_source_place_id',
          '(SELECT donor_name FROM $tblDonor WHERE donor_id=stock_donor_id) AS donor',
          'stock_donor_id'
        ],
        where: "stock_item_id=?",
        whereArgs: [itemId],
        groupBy:
            'stock_package_form_id, stock_exp_date, stock_batch, stock_source_place_id, stock_donor_id',
        having: 'SUM(stock_amount)>0');
  }

  // get all stock for item inventory screen
  Future<List<Map<String, dynamic>>> getAllStockByItem(itemId) async {
    _db = await _loadDatabase();
    return await _db.query(tblStock,
        columns: [
          'stock_id',
          'stock_date',
          'stock_type',
          '(SELECT source_place_name from $tblSourcePlace WHERE source_place_id=stock_source_place_id) AS source_place',
          '(SELECT donor_name FROM $tblDonor WHERE donor_id=stock_donor_id) AS donor',
          '(SELECT package_form_name FROM $tblPackageForm WHERE package_form_id=stock_package_form_id) AS package_form',
          'stock_amount',
          'stock_exp_date'
        ],
        where: 'stock_item_id=?',
        whereArgs: [itemId]);
  }

  // get top ten nearest expiry for info screen
  Future<List<Map<String, dynamic>>> getTopTenNearestExpiry() async {
    _db = await _loadDatabase();
    return await _db.query(tblStock,
        columns: [
          'stock_exp_date',
          // "SUBSTR(stock_exp_date, LENGTH(stock_exp_date)-3)||'-'||SUBSTR(stock_exp_date, INSTR(stock_exp_date, '-')+1,INSTR(stock_exp_date,'-')-1)||'-'||SUBSTR(stock_exp_date,1,INSTR(stock_exp_date,'-')-1)AS background_sort",
          'stock_item_id',
          '(SELECT item_name FROM $tblItem WHERE item_id=stock_item_id) AS item_name',
          '(SELECT item_type FROM $tblItem WHERE item_id=stock_item_id) AS item_type',
          'SUM(stock_amount) AS stock_amount',
          'stock_batch',
          '(SELECT source_place_name FROM $tblSourcePlace WHERE source_place_id=stock_source_place_id) AS source_place',
          'stock_source_place_id',
          '(SELECT donor_name FROM $tblDonor WHERE donor_id=stock_donor_id) AS donor',
          'stock_donor_id',
          '(SELECT package_form_name FROM $tblPackageForm WHERE package_form_id=stock_package_form_id) AS package_form',
          'stock_package_form_id'
        ],
        groupBy:
            'stock_exp_date, stock_item_id, stock_batch, stock_donor_id, stock_source_place_id, stock_package_form_id',
        having: "SUM(stock_amount)>0 AND stock_exp_date!=''",
        orderBy: 'stock_exp_date ASC',
        limit: 10);
  }

  // count of draft stock for notification icon
  Future<int> getCountDraftStock() async {
    _db = await _loadDatabase();
    final result = await _db.query(tblStock,
        columns: ['COUNT(*)'], where: "stock_draft=?", whereArgs: ['true']);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // get available batch for group dispense screen
  Future<List<Map<String, dynamic>>> getAvailableItem() async {
    _db = await _loadDatabase();
    return await _db.query(tblStock,
        columns: [
          '(SELECT item_name FROM $tblItem WHERE item_id=stock_item_id) AS item_name',
          '(SELECT item_type FROM $tblItem WHERE item_id=stock_item_id) AS item_type',
          'stock_item_id',
          'SUM(stock_amount) AS stock_amount',
          '(SELECT package_form_name FROM $tblPackageForm WHERE package_form_id=stock_package_form_id) AS package_form',
          '(SELECT source_place_name FROM $tblSourcePlace WHERE source_place_id=stock_source_place_id) AS source_place',
          '(SELECT donor_name FROM $tblDonor WHERE donor_id=stock_donor_id) AS donor',
          'stock_package_form_id',
          'stock_exp_date',
          'stock_batch',
          'stock_source_place_id',
          'stock_donor_id'
        ],
        groupBy:
            'stock_item_id, stock_package_form_id, stock_batch, stock_exp_date, stock_source_place_id, stock_donor_id',
        orderBy: 'stock_exp_date ASC',
        having: 'SUM(stock_amount)>0');
  }

  // prevent duplicate for draft dispense screen
  Future<int> getSameItemDraftStock(itemId) async {
    _db = await _loadDatabase();
    final result = await _db.query(tblStock,
        columns: ['COUNT(*)'],
        where: 'stock_draft=? AND stock_item_id=?',
        whereArgs: ['true', itemId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // list of draft items for dispense
  Future<List<Map<String, dynamic>>> getDraftDispense() async {
    _db = await _loadDatabase();
    return await _db.query(tblStock,
        columns: [
          'stock_id',
          '(SELECT item_name FROM $tblItem WHERE item_id=stock_item_id) AS item_name',
          'stock_item_id',
          '(SELECT item_type FROM $tblItem WHERE item_id=stock_item_id) AS item_type',
          'stock_amount',
          '(SELECT package_form_name FROM $tblPackageForm WHERE package_form_id=stock_package_form_id) AS package_form',
          'stock_package_form_id',
          'stock_exp_date',
          '(SELECT source_place_name FROM $tblSourcePlace WHERE source_place_id=stock_source_place_id) AS source_place',
          'stock_source_place_id',
          '(SELECT donor_name FROM $tblDonor WHERE donor_id=stock_donor_id) AS donor',
          'stock_donor_id',
          'stock_batch'
        ],
        where: 'stock_draft=?',
        whereArgs: ['true']);
  }

  // get single value reusable
  Future<Map<String, dynamic>?> getSingleValueReusable(String tableName,
      String singleColumnName, String filterColumnName, int filterValue) async {
    _db = await _loadDatabase();
    List<Map<String, dynamic>> result = await _db.query(tableName,
        columns: [singleColumnName],
        where: '$filterColumnName=?',
        whereArgs: [filterValue]);
    return result.isNotEmpty ? result.first : null;
  }

  // confirm checkout dispense
  Future<void> confirmCheckout(String stockDate, int destinationId) async {
    _db = await _loadDatabase();
    await _db.rawUpdate(
        'UPDATE $tblStock SET stock_date=?, stock_type=?, stock_to=?, stock_draft=? WHERE stock_draft=?',
        [stockDate, 'OUT', destinationId, 'settled', 'true']);
  }

  // export to qr
  Future<List<Map<String, dynamic>>> getDispenseBatch(
      int destinationId, String stockDate) async {
    _db = await _loadDatabase();
    return await _db.query(tblStock,
        columns: [
          'stock_item_id',
          'stock_package_form_id',
          'stock_exp_date',
          'stock_batch',
          'stock_amount',
          'stock_donor_id',
          'stock_remark'
        ],
        where: 'stock_draft=? AND stock_to=? AND stock_date=?',
        whereArgs: ['settled', destinationId, stockDate]);
  }

  // for generate qr page
  Future<List<Map<String, dynamic>>> getAllDispensed() async {
    _db = await _loadDatabase();
    return await _db.query(tblStock,
        columns: [
          '(SELECT destination_name FROM $tblDestination WHERE destination_id=stock_to) AS destination',
          'stock_date',
          'stock_to'
        ],
        where: 'stock_type=?',
        whereArgs: ['OUT'],
        groupBy: 'stock_date, stock_to',
        orderBy: 'stock_date DESC');
  }

  // for qr import
  Future<void> importQrToStock(List<Map<String, dynamic>> scannedList,
      String stockDate, int stockSourcePlaceId, String userId) async {
    _db = await _loadDatabase();
    for (var data in scannedList) {
      final stock = Stock.insertStock(
          stockDate: stockDate,
          stockType: 'IN',
          stockItemId: data['stock_item_id'],
          stockPackageFormId: data['stock_package_form_id'],
          stockExpDate: data['stock_exp_date'],
          stockBatch: data['stock_batch'],
          stockAmount: data['stock_amount'] * -1,
          stockSourcePlaceId: stockSourcePlaceId,
          stockDonorId: data['stock_donor_id'],
          stockRemark: data['stock_remark'],
          stockTo: 0,
          stockSync: '',
          stockCre: userId,
          stockDraft: '');
      try {
        await _db.insert(tblStock, stock);
        EasyLoading.showSuccess(
            'Successfully imported from QR\nQR မှရရှိသည့်အချက်အလက်များ ထည့်သွင်းပြီးပါပြီ');
      } catch (e) {
        EasyLoading.showError('$e');
      }
    }
  }

  // select for sync
  // stock
  Future<List<Map<String, dynamic>>> getAllStockForSync() async {
    _db = await _loadDatabase();
    return await _db.query(tblStock);
  }

  // item type
  Future<List<Map<String, dynamic>>> getAllItemTypeForSync() async {
    _db = await _loadDatabase();
    return await _db
        .query(tblItemType, where: 'item_type_editable=?', whereArgs: ['true']);
  }

  // item
  Future<List<Map<String, dynamic>>> getAllItemForSync() async {
    _db = await _loadDatabase();
    return await _db
        .query(tblItem, where: 'item_editable=?', whereArgs: ['true']);
  }

  // package form
  Future<List<Map<String, dynamic>>> getAllPackageFormForSync() async {
    _db = await _loadDatabase();
    return await _db.query(tblPackageForm,
        where: 'package_form_editable=?', whereArgs: ['true']);
  }

  // source place
  Future<List<Map<String, dynamic>>> getAllSourcePlaceForSync() async {
    _db = await _loadDatabase();
    return await _db.query(tblSourcePlace,
        where: 'source_place_editable=?', whereArgs: ['true']);
  }

  // donor
  Future<List<Map<String, dynamic>>> getAllDonorForSync() async {
    _db = await _loadDatabase();
    return await _db
        .query(tblDonor, where: 'donor_editable=?', whereArgs: ['true']);
  }

  // destination
  Future<List<Map<String, dynamic>>> getAllDestinationForSync() async {
    _db = await _loadDatabase();
    return await _db.query(tblDestination,
        where: 'destination_editable=?', whereArgs: ['true']);
  }

  // for restore stock
  Future<void> restoreStockTable(
      List<Map<String, dynamic>> retrievedList) async {
    _db = await _loadDatabase();
    for (var data in retrievedList) {
      final stock = Stock.insertStock(
          stockDate: data['stock_date'],
          stockType: data['stock_type'],
          stockItemId: int.tryParse(data['stock_item_id'])!,
          stockPackageFormId: int.tryParse(data['stock_package_form_id'])!,
          stockExpDate: data['stock_exp_date'],
          stockBatch: data['stock_batch'],
          stockAmount: int.tryParse(data['stock_amount'])!,
          stockSourcePlaceId: int.tryParse(data['stock_source_place_id'])!,
          stockDonorId: int.tryParse(data['stock_donor_id'])!,
          stockRemark: data['stock_remark'],
          stockTo: int.tryParse(data['stock_to'])!,
          stockSync: '',
          stockCre: data['stock_cre'],
          stockDraft: '');
      try {
        await _db.insert(tblStock, stock);
      } catch (e) {
        print('$e');
      }
    }
  }

  // for restore item type
  Future<void> restoreItemTypeTable(
      List<Map<String, dynamic>> retrievedList) async {
    _db = await _loadDatabase();
    for (var data in retrievedList) {
      final itemType = ItemType.insertItemType(
          itemTypeName: data['item_type_name'],
          itemTypeEditable: data['item_type_editable'],
          itemTypeCre: data['item_type_cre']);
      try {
        await _db.insert(tblItemType, itemType);
      } catch (e) {
        print('$e');
      }
    }
  }

  // for restore item
  Future<void> restoreItemTable(
      List<Map<String, dynamic>> retrievedList) async {
    _db = await _loadDatabase();
    for (var data in retrievedList) {
      final item = Item.insertItem(
          itemName: data['item_name'],
          itemType: data['item_type'],
          itemEditable: data['item_editable'],
          itemCre: data['item_cre']);
      try {
        await _db.insert(tblItem, item);
      } catch (e) {
        print('$e');
      }
    }
  }

  // for restore package form
  Future<void> restorePackageFormTable(
      List<Map<String, dynamic>> retrievedList) async {
    _db = await _loadDatabase();
    for (var data in retrievedList) {
      final packageForm = PackageForm.insertPackageForm(
          packageFormName: data['package_form_name'],
          packageFormEditable: data['package_form_editable'],
          packageFormCre: data['package_form_cre']);
      try {
        await _db.insert(tblPackageForm, packageForm);
      } catch (e) {
        print('$e');
      }
    }
  }

  // for restore source place
  Future<void> restoreSourcePlaceTable(
      List<Map<String, dynamic>> retrievedList) async {
    _db = await _loadDatabase();
    for (var data in retrievedList) {
      final sourcePlace = SourcePlace.insertSourcePlace(
          sourcePlaceName: data['source_place_name'],
          sourcePlaceEditable: data['source_place_editable'],
          sourcePlaceCre: data['source_place_cre']);
      try {
        await _db.insert(tblSourcePlace, sourcePlace);
      } catch (e) {
        print('$e');
      }
    }
  }

  // for restore donor
  Future<void> restoreDonorTable(
      List<Map<String, dynamic>> retrievedList) async {
    _db = await _loadDatabase();
    for (var data in retrievedList) {
      final donor = Donor.insertDonor(
          donorName: data['donor_name'],
          donorEditable: data['donor_editable'],
          donorCre: data['donor_cre']);
      try {
        await _db.insert(tblDonor, donor);
      } catch (e) {
        print('$e');
      }
    }
  }

  // for restore destination
  Future<void> restoreDestinationTable(
      List<Map<String, dynamic>> retrievedList) async {
    _db = await _loadDatabase();
    for (var data in retrievedList) {
      final destination = Destination.insertDestination(
          destinationName: data['destination_name'],
          destinationEditable: data['destination_editable'],
          destinationCre: data['destination_cre']);
      try {
        await _db.insert(tblDestination, destination);
      } catch (e) {
        print('$e');
      }
    }
  }
}
