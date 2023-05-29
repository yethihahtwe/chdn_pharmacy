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

class Destination {
  // insert new destination model
  static Map<String, dynamic> insertDestination(
      {required String destinationName,
      required String destinationEditable,
      required String destinationCre}) {
    return {
      'destination_name': destinationName,
      'destination_editable': destinationEditable,
      'destination_cre': destinationCre
    };
  }

  // update destination model
  static Map<String, dynamic> updateDestination(
      {required String destinationName}) {
    return {'destination_name': destinationName};
  }
}

/* The following are the menu classes */
// source place
class SourcePlaceMenu {
  final int id;
  final String name;
  SourcePlaceMenu(this.id, this.name);
}

// donor
class DonorMenu {
  final int id;
  final String name;
  DonorMenu(this.id, this.name);
}

// item
class ItemMenu {
  final int id;
  final String name;
  ItemMenu(this.id, this.name);
}

// package form
class PackageFormMenu {
  final int id;
  final String name;
  PackageFormMenu(this.id, this.name);
}

// stock
class Stock {
  static Map<String, dynamic> insertStock(
      {required String stockDate,
      required String stockType,
      required int stockItemId,
      required int stockPackageFormId,
      required String stockExpDate,
      required String stockBatch,
      required int stockAmount,
      required int stockSourcePlaceId,
      required int stockDonorId,
      required String stockRemark,
      required int stockTo,
      required String stockSync,
      required String stockCre,
      required String stockDraft}) {
    return {
      'stock_date': stockDate,
      'stock_type': stockType,
      'stock_item_id': stockItemId,
      'stock_package_form_id': stockPackageFormId,
      'stock_exp_date': stockExpDate,
      'stock_batch': stockBatch,
      'stock_amount': stockAmount,
      'stock_source_place_id': stockSourcePlaceId,
      'stock_donor_id': stockDonorId,
      'stock_remark': stockRemark,
      'stock_to': stockTo,
      'stock_sync': stockSync,
      'stock_cre': stockCre,
      'stock_draft': stockDraft
    };
  }
}

class ReusableMenuModel {
  final int id;
  final String name;
  ReusableMenuModel(this.id, this.name);
}
