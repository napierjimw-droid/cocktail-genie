import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Flutter equivalent of the Next.js storage.ts
/// Uses SharedPreferences instead of localStorage
class StorageService {
  static const _favKey = 'favorites';
  static const _ingredientsKey = 'my_ingredients';
  static const _journeyKey = 'my_journey';

  // ── Favorites ─────────────────────────────────────────────────────────────

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_favKey) ?? '[]';
    return List<String>.from(jsonDecode(raw));
  }

  static Future<bool> isFavorite(String id) async {
    final favs = await getFavorites();
    return favs.contains(id);
  }

  static Future<List<String>> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = await getFavorites();
    final updated = favs.contains(id)
        ? (favs..remove(id))
        : (favs..add(id));
    await prefs.setString(_favKey, jsonEncode(updated));
    return updated;
  }

  

  // ── My Ingredients ────────────────────────────────────────────────────────

  static Future<List<String>> getIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ingredientsKey) ?? '[]';
    return List<String>.from(jsonDecode(raw));
  }

  static Future<void> addIngredients(List<String> newIngredients) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getIngredients();
    final combined = {...existing, ...newIngredients}.toList();
    await prefs.setString(_ingredientsKey, jsonEncode(combined));
  }

  static Future<void> removeIngredient(String ingredient) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getIngredients();
    existing.remove(ingredient);
    await prefs.setString(_ingredientsKey, jsonEncode(existing));
  }

  static Future<void> clearIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ingredientsKey);
  }

  // ── My Journey ────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getJourney() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_journeyKey) ?? '[]';
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> addJourneyEntry(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final journey = await getJourney();
    journey.insert(0, entry); // newest first
    // Keep max 50 entries
    final trimmed = journey.take(50).toList();
    await prefs.setString(_journeyKey, jsonEncode(trimmed));
  }

  static Future<void> deleteJourneyEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final journey = await getJourney();
    journey.removeWhere((e) => e['id'] == id);
    await prefs.setString(_journeyKey, jsonEncode(journey));
  }
}