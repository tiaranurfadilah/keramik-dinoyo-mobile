import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const KeramikDinoyoApp());

class KeramikDinoyoApp extends StatelessWidget {
  const KeramikDinoyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kampung Keramik Dinoyo',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}