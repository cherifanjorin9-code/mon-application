import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dark_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KuizineApp());
}

class KuizineApp extends StatelessWidget {
  const KuizineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KUIZINE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: DarkTheme.dark,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
