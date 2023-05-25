import 'package:chdn_pharmacy/database/database_helper.dart';

class EditStock {
  static Future<void> saveStockData(String tableName, String columnName,
      String idColumn, var value, int id) async {
    DatabaseHelper()
        .updateSingleValue(tableName, columnName, idColumn, value, id);
  }
}
