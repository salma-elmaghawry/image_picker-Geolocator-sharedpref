import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferencesAsync _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferencesAsync();
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
      // Save all string values
      await _prefs.setString('name', name);
      await _prefs.setString('email', email);
      await _prefs.setString('jobTitle', jobTitle);
      await _prefs.setString('bio', bio);
      await _prefs.setString('address', address);

      // Save latitude only if it's not null
      if (latitude != null) {
        await _prefs.setDouble('latitude', latitude);
      }

      // Save longitude only if it's not null
      if (longitude != null) {
        await _prefs.setDouble('longitude', longitude);
      }

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
        'name': await _prefs.getString('name') ?? '',
        'email': await _prefs.getString('email') ?? '',
        'jobTitle': await _prefs.getString('jobTitle') ?? '',
        'bio': await _prefs.getString('bio') ?? '',
        'latitude': await _prefs.getDouble('latitude'),
        'longitude': await _prefs.getDouble('longitude'),
        'address': await _prefs.getString('address') ?? '',
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
  static Future<bool> hasData() async {
    final name = await _prefs.getString('name');
    return name != null && name.isNotEmpty;
  }
}
