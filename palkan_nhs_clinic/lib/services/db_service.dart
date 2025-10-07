import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  static const String usersBoxName = 'usersBox';
  static const String authBoxName = 'authBox';
  static const String bmiBoxName = 'bmiBox';
  static const String medsBoxName = 'medsBox';
  static const String foodsBoxName = 'foodsBox';
  static const String analyticsBoxName = 'analyticsBox';

  Future<void> init() async {
    await Hive.openBox(authBoxName);
    await Hive.openBox(usersBoxName);
    await Hive.openBox(bmiBoxName);
    await Hive.openBox(medsBoxName);
    await Hive.openBox(foodsBoxName);
    await Hive.openBox(analyticsBoxName);
  }

  Box get authBox => Hive.box(authBoxName);
  Box get usersBox => Hive.box(usersBoxName);
  Box get bmiBox => Hive.box(bmiBoxName);
  Box get medsBox => Hive.box(medsBoxName);
  Box get foodsBox => Hive.box(foodsBoxName);
  Box get analyticsBox => Hive.box(analyticsBoxName);

  // Helpers to store JSON-serializable maps/lists as strings for safety.
  Future<void> putJson(Box box, String key, Object value) async {
    await box.put(key, jsonEncode(value));
  }

  T? getJson<T>(Box box, String key) {
    final raw = box.get(key);
    if (raw == null) return null;
    if (raw is String) {
      return jsonDecode(raw) as T;
    }
    return raw as T?; // fallback if already object
  }
}
