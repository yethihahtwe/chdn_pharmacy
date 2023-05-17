import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database _db;
  static const String tblItemType = 'tbl_item_type';
  static const String tblItem = 'tbl_item';
  static const String tblPackageForm = 'tbl_package_form';

  static var instance;
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
        where: "package_form_id", whereArgs: [id]);
  }

  // delete
  Future<int> deletePackageForm(int id) async {
    _db = await _loadDatabase();
    return await _db
        .delete(tblPackageForm, where: "package_form_id", whereArgs: [id]);
  }
}
