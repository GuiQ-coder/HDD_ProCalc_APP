import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HDD ProCalc',
      theme: appTheme,
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}