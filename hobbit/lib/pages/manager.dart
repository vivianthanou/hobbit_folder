import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const _userIdKey = 'user_id';

  // Save the user ID
  static Future<void> saveUserId(int userId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_userIdKey, userId);
  }

  // Get the user ID
  static Future<int?> getUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_userIdKey);
  }

  // Remove the user ID (useful when logging out)
  static Future<void> removeUserId() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userIdKey);
  }
}
