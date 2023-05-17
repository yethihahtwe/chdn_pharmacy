class ItemType {
  // insert new item type model
  static Map<String, dynamic> insertItemType(
      {required String itemTypeName,
      required String itemTypeEditable,
      required String itemTypeCre}) {
    return {
      'item_type_name': itemTypeName,
      'item_type_editable': itemTypeEditable,
      'item_type_cre': itemTypeCre
    };
  }

  // update item type model
  static Map<String, dynamic> updateItemType({required String itemTypeName}) {
    return {'item_type_name': itemTypeName};
  }
}

class Item {
  // insert new item model
  static Map<String, dynamic> insertItem(
      {required String itemName,
      required String itemType,
      required String itemEditable,
      required String itemCre}) {
    return {
      'item_name': itemName,
      'item_type': itemType,
      'item_editable': itemEditable,
      'item_cre': itemCre
    };
  }

  // update item model
  static Map<String, dynamic> updateItem(
      {required String itemName, required String itemType}) {
    return {'item_name': itemName, 'item_type': itemType};
  }
}

class PackageForm {
  // insert new package form model
  static Map<String, dynamic> insertPackageForm(
      {required String packageFormName,
      required String packageFormEditable,
      required String packageFormCre}) {
    return {
      'package_form_name': packageFormName,
      'package_form_editable': packageFormEditable,
      'package_form_cre': packageFormCre
    };
  }

  // update package form model
  static Map<String, dynamic> updatePackageForm(
      {required String packageFormName}) {
    return {'package_form_name': packageFormName};
  }
}
