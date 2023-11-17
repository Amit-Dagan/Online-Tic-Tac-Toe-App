import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences; // Change to nullable
  static const _accessKey = 'accessKey';
  static const _reRefreshKey = 'refreshKey';
  static const _idKey = 'idKey';

  static Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future setAccessKey(String accessKey) async {
    await init(); // Ensure preferences are initialized
    await _preferences!.setString(_accessKey, accessKey);
  }

  static String? getAccessKey() {
    return _preferences?.getString(_accessKey);
  }

  static Future setRefreshKey(String refreshKey) async {
    await init(); // Ensure preferences are initialized
    await _preferences!.setString(_reRefreshKey, refreshKey);
  }

  static String? getRefreshKey() {
    return _preferences?.getString(_reRefreshKey);
  }
}
