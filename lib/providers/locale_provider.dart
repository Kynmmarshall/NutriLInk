import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() {
    final savedLocale = StorageService.getLocale();
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    await StorageService.saveLocale(locale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    if (_locale.languageCode == 'en') {
      await setLocale(const Locale('fr'));
    } else {
      await setLocale(const Locale('en'));
    }
  }
}
