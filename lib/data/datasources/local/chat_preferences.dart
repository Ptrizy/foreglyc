import 'package:shared_preferences/shared_preferences.dart';

class ChatPreferences {
  static const String _chatKey = 'foreglyc_expert_chat';

  Future<bool> saveChat(String chatJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_chatKey, chatJson);
    } catch (e) {
      throw Exception('Failed to save chat to preferences: ${e.toString()}');
    }
  }

  Future<String?> loadChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_chatKey);
    } catch (e) {
      throw Exception('Failed to load chat from preferences: ${e.toString()}');
    }
  }

  Future<bool> deleteChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_chatKey);
    } catch (e) {
      throw Exception(
        'Failed to delete chat from preferences: ${e.toString()}',
      );
    }
  }
}
