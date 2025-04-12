import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_hdd_app/routes.dart';
import 'package:test_hdd_app/providers/locale_provider.dart';
import 'package:test_hdd_app/theme.dart';
import 'l10n.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      darkTheme: appTheme,
      localizationsDelegates: L10n.delegates,
      supportedLocales: L10n.supportedLocales,
      locale: localeProvider.locale,
      initialRoute: '/',
      routes: appRoutes,
      onGenerateRoute: generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('Página no encontrada')),
        ),
      ),
    );
  }
}