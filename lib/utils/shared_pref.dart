import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/constants.dart';

class SharedPref {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<String> getJson(String key) async {
    final SharedPreferences prefs = await _prefs;
    return json.decode(prefs.getString(key)!) ?? '';
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await _prefs;
    final isRemember = prefs.getBool(key);
    return isRemember;
  }

  static Future setJson(String key, dynamic value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key, json.encode(value));
  }

  static Future saveUser(String username) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(Constants.user, username);
  }

  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await _prefs;
    String? userName = prefs.getString(Constants.user);
    return userName;
  }

  static Future clear() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }

  static Future remove(String key) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(key);
  }

  static Future cleanAll() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }
}
