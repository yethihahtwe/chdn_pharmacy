import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

  // select for history screen
  Future<List<Map<String, dynamic>>> getAllStock() async {
    _db = await _loadDatabase();
    return await _db.rawQuery(
        'SELECT stock_item_id, stock_date, stock_type, (SELECT item_name FROM $tblItem WHERE item_id=stock_item_id) AS item_name, (SELECT item_type FROM $tblItem WHERE item_id=stock_item_id) AS item_type, (SELECT package_form_name from $tblPackageForm WHERE package_form_id=stock_package_form_id) AS stock_package_form, stock_amount, stock_sync FROM tbl_stock');
  }

  // select group by for home screen
  Future<List<Map<String, dynamic>>> getAllBalance() async {
    _db = await _loadDatabase();
    return await _db.rawQuery(
        'SELECT stock_item_id, (SELECT item_name FROM $tblItem WHERE item_id=stock_item_id) AS item_name, (SELECT item_type FROM $tblItem WHERE item_id=stock_item_id) AS item_type, SUM(stock_amount) AS stock_amount FROM tbl_stock GROUP BY stock_item_id, item_name, item_type HAVING SUM(stock_amount) >0;');
  }
}
