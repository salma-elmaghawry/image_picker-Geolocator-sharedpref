import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // Save user data
  static Future<bool> saveUserData({
    required String name,
    required String email,
    required String jobTitle,
    required String bio,
    required double? latitude,
    required double? longitude,
    required String address,
    String? profileImagePath,
  }) async {
    try {
      await _prefs.setString('name', name);
      await _prefs.setString('email', email);
      await _prefs.setString('jobTitle', jobTitle);
      await _prefs.setString('bio', bio);
      if (latitude != null) {
        await _prefs.setDouble('latitude', latitude);
      }
      if (longitude != null) {
        await _prefs.setDouble('longitude', longitude);
      }
      await _prefs.setString('address', address);
      if (profileImagePath != null) {
        await _prefs.setString('profileImagePath', profileImagePath);
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
        'profileImagePath': await _prefs.getString('profileImagePath'),
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
    return _prefs.containsKey('name');
  }
}
