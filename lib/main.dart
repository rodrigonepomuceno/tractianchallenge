import 'package:flutter/material.dart';
import 'package:tractianchallenge/core/theme/app_theme.dart';
import 'package:tractianchallenge/injections.dart';
import 'package:tractianchallenge/src/presentation/splash/page/splash_page.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tractian Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
