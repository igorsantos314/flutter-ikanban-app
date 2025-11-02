import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  SharedPrefsService._();
  static final SharedPrefsService instance = SharedPrefsService._();

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Primitivos
  Future<bool> setBool(String key, bool value) async {
    final p = await _prefs;
    return p.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final p = await _prefs;
    return p.containsKey(key) ? p.getBool(key) : null;
  }

  Future<bool> setInt(String key, int value) async {
    final p = await _prefs;
    return p.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final p = await _prefs;
    return p.containsKey(key) ? p.getInt(key) : null;
  }

  Future<bool> setDouble(String key, double value) async {
    final p = await _prefs;
    return p.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final p = await _prefs;
    return p.containsKey(key) ? p.getDouble(key) : null;
  }

  Future<bool> setString(String key, String value) async {
    final p = await _prefs;
    return p.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final p = await _prefs;
    return p.containsKey(key) ? p.getString(key) : null;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final p = await _prefs;
    return p.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final p = await _prefs;
    return p.containsKey(key) ? p.getStringList(key) : null;
  }

  Future<bool> remove(String key) async {
    final p = await _prefs;
    return p.remove(key);
  }

  Future<bool> clear() async {
    final p = await _prefs;
    return p.clear();
  }

  // Exemplo: salvar objeto serializado (usar jsonEncode/jsonDecode)
  Future<bool> setObject<T>(String key, T object) async {
    final p = await _prefs;
    final json = jsonEncode(object);
    return p.setString(key, json);
  }

  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final p = await _prefs;
    if (!p.containsKey(key)) return null;
    final jsonString = p.getString(key);
    if (jsonString == null) return null;
    final Map<String, dynamic> map = jsonDecode(jsonString);
    return fromJson(map);
  }
}
