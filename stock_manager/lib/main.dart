import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/theme_provider.dart';

//import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/screens/splash_screen.dart';
import 'package:stock_manager/screens/login_screen.dart';
import 'package:stock_manager/screens/home_screen.dart';

// Créez une instance globale ou accédez à l'instance de votre service de notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Votre fonction main (Doit être la seule fonction main dans ce fichier)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  // 1. Définir un GUID (Identifiant unique) et un AppUserModelId
  const String appGuid =
      '6e72b0c9-4674-4531-9f93-57530666014b'; // Exemple de GUID
  const String appModelId =
      'com.example.stock_manager'; // Généralement votre package name

  const initializationSettingsWindows = WindowsInitializationSettings(
    appName: 'Stock Manager App',
    appUserModelId: appModelId,
    guid: appGuid,
  );

  const initializationSettings = InitializationSettings(
    windows: initializationSettingsWindows,
    // Ajoutez des configurations pour Android et iOS si vous lancez sur mobile :
    // android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  // CORRECTION MAJEURE : Encapsuler StockManagerApp dans le ThemeProvider
  // pour que le Consumer (à l'intérieur) puisse y accéder.
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const StockManagerApp(),
    ),
  );
}

// NOTE : La classe 'MyApp' qui était précédemment ici a été supprimée
// car elle était un doublon de 'StockManagerApp'.

class StockManagerApp extends StatelessWidget {
  const StockManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Le Consumer peut maintenant fonctionner car son parent immédiat est le ThemeProvider
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Stock Manager',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // ... (votre thème clair)
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          darkTheme: ThemeData(
            // ... (votre thème sombre)
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          themeMode: themeProvider.themeMode, // Utilisation correcte du thème
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