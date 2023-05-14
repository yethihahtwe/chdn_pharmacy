class ItemType {
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
}
