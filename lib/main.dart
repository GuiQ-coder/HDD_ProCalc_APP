import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'app.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false, // Desactiva en producción
      builder: (context) => const MyApp(),
    ),
  );
}