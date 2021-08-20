import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {
  static const String KEY_LOGGED_IN = "logged_in";
  static const String KEY_USERNAME = "username";
  static const String KEY_USERID = "userId";
  static const String KEY_USER = "user";

  //Provide preference data based on key, type of data depends on default value
  static Future<dynamic> getValue(String key,
      {dynamic defaultValue = ""}) async {
    var sharedPreference = await SharedPreferences.getInstance();

    if (defaultValue is String) return sharedPreference.getString(key);
    if (defaultValue is int) return sharedPreference.getInt(key);
    if (defaultValue is bool) return sharedPreference.getBool(key);
    if (defaultValue is double) return sharedPreference.getDouble(key);

    return sharedPreference.get(key);
  }

  //Saved data in preference, type of data depends on default value
  static Future<bool> setValue(String key, dynamic value) async {
    var sharedPreference = await SharedPreferences.getInstance();

    if (value is String) return sharedPreference.setString(key, value);
    if (value is int) return sharedPreference.setInt(key, value);
    if (value is bool) return sharedPreference.setBool(key, value);
    if (value is double) return sharedPreference.setDouble(key, value);

    return false;
  }
}
