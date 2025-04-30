import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyRememberMe = 'rememberMe';
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';

  /// Checks if user is currently logged in.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Attempts to log in with [username] and [password].
  /// Returns true on success.
  Future<bool> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    // TODO: Replace hardcoded check with real authentication if needed.
    final success = (username == 'user' && password == 'user');
    if (!success) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);

    if (rememberMe) {
      await prefs.setBool(_keyRememberMe, true);
      await prefs.setString(_keyUsername, username);
      await prefs.setString(_keyPassword, password);
    } else {
      await prefs.setBool(_keyRememberMe, false);
      await prefs.remove(_keyUsername);
      await prefs.remove(_keyPassword);
    }

    return true;
  }

  /// Logs out the user.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// Returns saved credentials if “remember me” was checked.
  Future<Credential?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    if (!rememberMe) return null;

    final username = prefs.getString(_keyUsername) ?? '';
    final password = prefs.getString(_keyPassword) ?? '';
    return Credential(username: username, password: password);
  }
}

class Credential {
  final String username;
  final String password;

  Credential({required this.username, required this.password});
}
