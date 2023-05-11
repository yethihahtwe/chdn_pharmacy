import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _LstItemType = prefs.getStringList('LstItemType') ?? _LstItemType;
    _LstPackageForm = prefs.getStringList('LstPackageForm') ?? _LstPackageForm;
    _LstSourcePlace = prefs.getStringList('LstSourcePlace') ?? _LstSourcePlace;
    _LstDonor = prefs.getStringList('LstDonor') ?? _LstDonor;
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  // prebuilt item type list
  List<String> _LstItemType = [
    'Oral',
    'Injection',
    'Topical',
    'Equipment',
    'Supply',
    'Vaccine',
    'Warehouse supply'
  ];

  // retrieve item type list
  List<String> get LstItemType => _LstItemType;
  set LstItemType(List<String> _value) {
    _LstItemType = _value;
    prefs.setStringList('LstItemType', _value);
  }

  // insert to item type list
  void addToItemType(String _value) {
    _LstItemType.add(_value);
    prefs.setStringList('LstItemType', _LstItemType);
  }

  // delete from item type list
  void removeFromItemType(String _value) {
    _LstItemType.remove(_value);
    prefs.setStringList('LstItemType', _LstItemType);
  }

  // delete from item type at index
  void removeAtIndexFromItemType(int _index) {
    _LstItemType.removeAt(_index);
    prefs.setStringList('LstItemType', _LstItemType);
  }

  // prebuilt package form list
  List<String> _LstPackageForm = [
    'Tablet',
    'Capsule',
    'Ampoule',
    'Vial',
    'Bottle',
    'Piece',
    'Tube',
    'Pair',
    'Sheet',
    'Set',
    'Roll',
    'Pack',
    'Sachet',
    'Box',
    'Each'
  ];

  // retrieve package form list
  List<String> get LstPackageForm => _LstPackageForm;
  set LstPackageForm(List<String> _value) {
    _LstPackageForm = _value;
    prefs.setStringList('LstPackageform', _value);
  }

  // insert to package form list
  void addToPackageForm(String _value) {
    _LstPackageForm.add(_value);
    prefs.setStringList('LstPackageForm', _LstPackageForm);
  }

  // delete from package form list
  void removeFromPackageForm(String _value) {
    _LstPackageForm.remove(_value);
    prefs.setStringList('LstPackageForm', _LstPackageForm);
  }

  // delete from package form at index
  void removeAtIndexFromPackageForm(int _index) {
    _LstPackageForm.removeAt(_index);
    prefs.setStringList('LstPackageForm', _LstPackageForm);
  }

  // build an empty source place list
  List<String> _LstSourcePlace = [];

  // retrieve from source place list
  List<String> get LstSourcePlace => _LstSourcePlace;
  set LstSourcePlace(List<String> _value) {
    _LstSourcePlace = _value;
    prefs.setStringList('LstSourcePlace', _value);
  }

  // insert to source place list
  void addToSourcePlace(String _value) {
    _LstSourcePlace.add(_value);
    prefs.setStringList('LstSourcePlace', _LstSourcePlace);
  }

  // delete from source place list
  void removeFromSourcePlace(String _value) {
    _LstSourcePlace.remove(_value);
    prefs.setStringList('LstSourcePlace', _LstSourcePlace);
  }

  // delete from source place at index
  void removeAtIndexFromSourcePlace(int _index) {
    _LstSourcePlace.removeAt(_index);
    prefs.setStringList('LstSourcePlace', _LstSourcePlace);
  }

  // build an empty donor list
  List<String> _LstDonor = [];

  // retrieve from donor list
  List<String> get LstDonor => _LstDonor;
  set LstDonor(List<String> _value) {
    _LstDonor = _value;
    prefs.setStringList('LstDonor', _value);
  }

  // insert to donor list
  void addToDonor(String _value) {
    _LstDonor.add(_value);
    prefs.setStringList('LstDonor', _LstDonor);
  }

  // delete from donor list
  void removeFromDonor(String _value) {
    _LstDonor.remove(_value);
    prefs.setStringList('LstDonor', _LstDonor);
  }

  // delete from donor list at index
  void removeAtIndexFromDonor(int _index) {
    _LstDonor.removeAt(_index);
    prefs.setStringList('LstDonor', _LstDonor);
  }
}
