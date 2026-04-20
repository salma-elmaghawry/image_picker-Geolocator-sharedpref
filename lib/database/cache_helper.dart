import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferencesAsync _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferencesAsync();
  }

  static Future<bool> SaveUserData({
    required String name,
    required String email,
    required String jobTitle,
    required String bio,
    required double? latitude,
    required double? longitude,
    required String address,
    String? imagePath,
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
      if (imagePath != null && imagePath.isNotEmpty) {
        await _prefs.setString('imagePath', imagePath);
      }
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

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
        'imagePath': await _prefs.getString('imagePath'),
      };
    } catch (e) {
      print('Error loading user data: $e');
      return {};
    }
  }

  static Future<bool> clearUserData() async {
    try {
      await _prefs.clear();
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  static Future<bool> hasData() async {
    final name = await _prefs.getString('name');
    return name != null && name.isNotEmpty;
  }
}
