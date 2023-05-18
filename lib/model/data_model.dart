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

class SourcePlace {
  // insert new source place model
  static Map<String, dynamic> insertSourcePlace(
      {required String sourcePlaceName,
      required String sourcePlaceEditable,
      required String sourcePlaceCre}) {
    return {
      'source_place_name': sourcePlaceName,
      'source_place_editable': sourcePlaceEditable,
      'source_place_cre': sourcePlaceCre
    };
  }

  // update source place model
  static Map<String, dynamic> updateSourcePlace(
      {required String sourcePlaceName}) {
    return {'source_place_name': sourcePlaceName};
  }
}

class Donor {
  // insert new donor model
  static Map<String, dynamic> insertDonor(
      {required String donorName,
      required String donorEditable,
      required String donorCre}) {
    return {
      'donor_name': donorName,
      'donor_editable': donorEditable,
      'donor_cre': donorCre
    };
  }

  // update donor model
  static Map<String, dynamic> updateDonor({required String donorName}) {
    return {'donor_name': donorName};
  }
}
