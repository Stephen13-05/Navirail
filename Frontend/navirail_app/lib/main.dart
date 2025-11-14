import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'ui/design_system.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NaviRail',
      theme: AppTheme.light,
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
