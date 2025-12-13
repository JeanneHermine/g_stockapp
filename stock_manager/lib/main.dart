import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/theme_provider.dart';
import 'package:stock_manager/screens/splash_screen.dart';
import 'package:stock_manager/screens/login_screen.dart';
import 'package:stock_manager/screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Stock Manager',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(userName: 'Utilisateur'),
          },
        );
      },
    );
  }
}
