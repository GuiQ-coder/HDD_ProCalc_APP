import 'package:flutter/material.dart';
import 'screens/disclaimer/disclaimer_page.dart';
import 'screens/menu/menu_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const DisclaimerPage(),
  '/menu': (context) => const MenuPage(),
};