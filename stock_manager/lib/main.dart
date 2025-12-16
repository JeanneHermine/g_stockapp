import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/theme_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // AJOUTER kIsWeb
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

 // On n'initialise sqflite_ffi que si on n'est PAS sur le Web
if (!kIsWeb) {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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

  // **CORRECTION VALIDÉE**
  const initializationSettings = InitializationSettings(
    windows: initializationSettingsWindows,
    // AJOUTÉ : Utilise l'icône Android par défaut pour la notification
    android: AndroidInitializationSettings('ic_launcher'), 
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
            // Professional neutral theme
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.blueGrey.withValues(alpha: 0.1),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              fillColor: Colors.blueGrey.shade50,
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.blueGrey.shade50,
              foregroundColor: Colors.blueGrey.shade900,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          darkTheme: ThemeData(
            // Professional neutral dark theme
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.blueGrey.withValues(alpha: 0.2),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              fillColor: Colors.blueGrey.shade900,
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.blueGrey.shade900,
              foregroundColor: Colors.blueGrey.shade100,
              surfaceTintColor: Colors.transparent,
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