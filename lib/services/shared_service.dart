import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static const _keys = {
    'name': 'name',
    'phone': 'phone',
    'email': 'email',
    'address': 'address',
    'gender': 'gender',
    'bloodGroup': 'bloodGroup',
    'dob': 'dob',
  };

  static const _donorsCountKey = 'donorsCount';

  /// Save user data into SharedPreferences
  static Future<void> saveUserData({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String gender,
    required String bloodGroup,
    required String dob,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keys['name']!, name);
    await prefs.setString(_keys['phone']!, phone);
    await prefs.setString(_keys['email']!, email);
    await prefs.setString(_keys['address']!, address);
    await prefs.setString(_keys['gender']!, gender);
    await prefs.setString(_keys['bloodGroup']!, bloodGroup);
    await prefs.setString(_keys['dob']!, dob);

    print("✅ User data saved to SharedPreferences.");
  }

  /// Retrieve user data from SharedPreferences
  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      'name': prefs.getString(_keys['name']!) ?? '',
      'phone': prefs.getString(_keys['phone']!) ?? '',
      'email': prefs.getString(_keys['email']!) ?? '',
      'address': prefs.getString(_keys['address']!) ?? '',
      'gender': prefs.getString(_keys['gender']!) ?? '',
      'bloodGroup': prefs.getString(_keys['bloodGroup']!) ?? '',
      'dob': prefs.getString(_keys['dob']!) ?? '',
    };

    print("📦 Retrieved user data from SharedPreferences: $data");

    return data;
  }

  /// Clear all stored user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🧹 Cleared all user data from SharedPreferences.");
  }

  /// Save donors count map locally
  static Future<void> saveDonorsCount(Map<String, int> donorsCount) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(donorsCount);
    await prefs.setString(_donorsCountKey, jsonStr);
    print("✅ Donors count saved locally.");
  }

  /// Get donors count map from SharedPreferences
  static Future<Map<String, int>> getDonorsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_donorsCountKey);
    if (jsonStr == null) return {};
    final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return jsonMap.map((key, value) => MapEntry(key, value as int));
  }
}
