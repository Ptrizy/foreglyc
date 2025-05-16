import 'package:foreglyc/data/datasources/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String _tokenKey = 'AUTH_TOKEN';
  static const String _idVerifyKey = 'ID_VERIFY';

  static Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      AppLogger.info('Sukses menyimpan token');
      return true;
    } catch (e) {
      AppLogger.error('Error saat menyimpan token', e);
      return false;
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      AppLogger.debug(token.toString());
      if (token != null) {
        AppLogger.info('Sukses mengembalikan token');
      } else {
        AppLogger.info('Tidak ada token!');
      }
      return token;
    } catch (e) {
      AppLogger.error('Error saat mengembalikan token', e);
      return null;
    }
  }

  static Future<bool> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      AppLogger.info('Sukses menghapus token');
      return true;
    } catch (e) {
      AppLogger.error('Error saat menghapus token', e);
      return false;
    }
  }

  static Future<bool> saveId(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_idVerifyKey, id);
      AppLogger.info('Sukses menyimpan ID untuk Verify');
      return true;
    } catch (e) {
      AppLogger.error('Error saat menyimpan ID', e);
      return false;
    }
  }

  static Future<String?> getId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_idVerifyKey);
      if (token != null) {
        AppLogger.info('Sukses mengembalikan ID Verify');
      } else {
        AppLogger.info('Tidak ada ID Verify!');
      }
      return token;
    } catch (e) {
      AppLogger.error('Error saat mengembalikan ID', e);
      return null;
    }
  }

  static Future<bool> deleteId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_idVerifyKey);
      AppLogger.info('Sukses menghapus id verify');
      return true;
    } catch (e) {
      AppLogger.error('Error saat menghapus id', e);
      return false;
    }
  }
}
