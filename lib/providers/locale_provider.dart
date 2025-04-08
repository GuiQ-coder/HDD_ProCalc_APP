import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;
  
  LocaleProvider() : _locale = _getDefaultLocale();

  static Locale _getDefaultLocale() {
    // Puedes implementar lógica para detectar el idioma del sistema
    return const Locale('es'); // Español como predeterminado
  }

  Locale get locale => _locale;
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}