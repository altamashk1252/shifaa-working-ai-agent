import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static final ValueNotifier<String> languageNotifier =
  ValueNotifier<String>('en');

  static Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    languageNotifier.value = prefs.getString('language') ?? 'en';
  }

  static Future<void> setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
    languageNotifier.value = langCode; // notify listeners
  }
}
