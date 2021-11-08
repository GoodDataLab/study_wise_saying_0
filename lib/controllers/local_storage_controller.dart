import 'package:shared_preferences/shared_preferences.dart';

LocalStorageController localStorageController = LocalStorageController();

class LocalStorageController {
  SharedPreferences? _prefs;

  LocalStorageController() {
    init();
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getUserEmail() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs!.getString('userEmail');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> setUserEmail(String value) async {
    _prefs = await SharedPreferences.getInstance();
    try {
      _prefs!.setString('userEmail', value);
      print('$value success');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setSavedPostIds(List<String> ids) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.remove('savedPost');
    _prefs!.setStringList('savedPost', ids);
  }

  Future<List<String>> getSavedPostIds() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? result = _prefs!.getStringList('savedPost');
    if (result == null) {
      return [];
    } else {
      return result;
    }
  }
}
