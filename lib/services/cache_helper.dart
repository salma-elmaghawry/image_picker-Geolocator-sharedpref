import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user data
  static Future<bool> saveUserData({
    required String name,
    required String email,
    required String jobTitle,
    required String bio,
    required double? latitude,
    required double? longitude,
    required String address,
  }) async {
    try {
      await Future.wait([
        _prefs.setString('name', name),
        _prefs.setString('email', email),
        _prefs.setString('jobTitle', jobTitle),
        _prefs.setString('bio', bio),
        latitude != null
            ? _prefs.setDouble('latitude', latitude)
            : Future.value(true),
        longitude != null
            ? _prefs.setDouble('longitude', longitude)
            : Future.value(true),
        _prefs.setString('address', address),
      ]);
      return true;
    } catch (e) {
      print('Error saving data: $e');
      return false;
    }
  }

  // Load user data
  static Future<Map<String, dynamic>> loadUserData() async {
    try {
      return {
        'name': _prefs.getString('name') ?? '',
        'email': _prefs.getString('email') ?? '',
        'jobTitle': _prefs.getString('jobTitle') ?? '',
        'bio': _prefs.getString('bio') ?? '',
        'latitude': _prefs.getDouble('latitude'),
        'longitude': _prefs.getDouble('longitude'),
        'address': _prefs.getString('address') ?? '',
      };
    } catch (e) {
      print('Error loading data: $e');
      return {};
    }
  }

  // Remove all saved data
  static Future<bool> removeAllData() async {
    try {
      await _prefs.clear();
      return true;
    } catch (e) {
      print('Error removing data: $e');
      return false;
    }
  }

  // Check if data exists
  static bool hasData() {
    return _prefs.containsKey('name');
  }
}
