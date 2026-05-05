import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/dictionary.dart';

class LanguageProvider extends ChangeNotifier {
  static const _key = 'cocktail_lang';
  String _lang = 'EN';

  String get lang => _lang;

  /// Translate a key to the current language.
  /// Falls back to the key itself if not found — same as your Next.js t()
  String t(String key) {
    return dictionary[_lang]?[key] ?? key;
  }

  /// Load saved language from SharedPreferences on app start
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null && dictionary.containsKey(saved)) {
      _lang = saved;
      notifyListeners();
    }
  }

  /// Change language and persist it
  Future<void> setLang(String newLang) async {
    if (!dictionary.containsKey(newLang)) return;
    _lang = newLang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newLang);
  }

  /// All available language codes
  List<String> get languages => dictionary.keys.toList();
}