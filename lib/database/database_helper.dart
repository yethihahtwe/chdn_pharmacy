import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database _db;
  static const String tblItemType = 'tbl_item_type';

  static var instance;
  DatabaseHelper() {
    _loadDatabase();
  }

  // // create database
  // Future<Database> _createDatabase() async {
  //   var dataPath = await getDatabasesPath();
  //   String path = join(dataPath, "pharmacy.db");
  //   _db = await openDatabase(path);

// open database
  Future<Database> _loadDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pharmacy.db");
    _db = await openDatabase(path);

    // // create tables
    // // create item type table
    // await _db.execute(
    //     'CREATE TABLE IF NOT EXISTS $tblItemType(item_type_id INTEGER PRIMARY KEY, item_type_name TEXT, item_type_editable TEXT);');
    return _db;
  }

  // database actions
  // insert into item type table
  Future<int> insertItemType(Map<String, dynamic> itemType) async {
    _db = await _loadDatabase();
    return await _db.insert(tblItemType, itemType);
  }

  // select * from item type table
  Future<List<Map<String, dynamic>>> getAllItemType() async {
    _db = await _loadDatabase();
    return await _db
        .rawQuery('SELECT * FROM $tblItemType ORDER BY item_type_id asc');
  }

  // update item type table
  Future<int> updateItemType(Map<String, dynamic> itemType, int id) async {
    _db = await _loadDatabase();
    return await _db.update(tblItemType, itemType,
        where: "item_type_id=?", whereArgs: [id]);
  }

  // delete item type row
  Future<int> deleteItemType(int id) async {
    _db = await _loadDatabase();
    return await _db
        .delete(tblItemType, where: "item_type_id=?", whereArgs: [id]);
  }
}
