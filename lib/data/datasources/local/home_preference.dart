import 'package:foreglyc/data/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePreferences {
  static const String glucoKey = 'gluco';
  static const String cgmKey = 'cgm';
  static const String nameKey = 'name';
  static const String urlPhotoKey = 'urlphoto';
  static const String levelKey = 'level';

  Future<bool> saveHome(HomeResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        glucoKey,
        response.data.isGlucometerMonitoringPreferenceAvailable.toString(),
      );
      await prefs.setString(
        cgmKey,
        response.data.isCGMMonitoringPreferenceAvailable.toString(),
      );
      await prefs.setString(nameKey, response.data.fullName);
      await prefs.setString(urlPhotoKey, response.data.photoProfile);
      await prefs.setString(levelKey, response.data.level);
      return true;
    } catch (e) {
      throw Exception(
        'Failed to save home response to preferences: ${e.toString()}',
      );
    }
  }

  Future<Map<String, String?>> loadHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        glucoKey: prefs.getString(glucoKey),
        cgmKey: prefs.getString(cgmKey),
        nameKey: prefs.getString(nameKey),
        urlPhotoKey: prefs.getString(urlPhotoKey),
        levelKey: prefs.getString(levelKey),
      };
    } catch (e) {
      throw Exception('Failed to load Home from preferences: ${e.toString()}');
    }
  }

  Future<bool> deleteHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(glucoKey);
      await prefs.remove(cgmKey);
      await prefs.remove(nameKey);
      await prefs.remove(urlPhotoKey);
      await prefs.remove(levelKey);
      return true;
    } catch (e) {
      throw Exception(
        'Failed to delete Home from preferences: ${e.toString()}',
      );
    }
  }

  Future<bool> isCGMConnected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cgmKey) == 'true';
  }

  Future<bool> isGlucoConnected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(glucoKey) == 'true';
  }
}
