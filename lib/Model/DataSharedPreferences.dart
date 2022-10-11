import 'package:shared_preferences/shared_preferences.dart';

class DataSharedPreferences {
  void saveString(String name, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(name, value);
  }

  void saveInt(String name, int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(name, value);
  }

  void saveDouble(String name, double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(name, value);
  }

  Future<String> readString(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(value);
  }

  Future<int> readInt(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(value);
  }

  Future<double> readDouble(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(value);
  }

  void clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  Future<bool> checkData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(name);
  }
}
