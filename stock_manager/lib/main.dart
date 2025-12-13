import 'package:flutter/material.dart';
import 'package:stock_manager/database/database_helper.dart';
import 'package:stock_manager/screens/login_screen.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await DatabaseHelper.instance.database;
runApp(const StockManagerApp());
}

class StockManagerApp extends StatelessWidget {
const StockManagerApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: ‘Stock Manager’,
debugShowCheckedModeBanner: false,
theme: ThemeData(
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.deepPurple,
brightness: Brightness.light,
),
useMaterial3: true,
cardTheme: CardTheme(
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
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.deepPurple,
brightness: Brightness.dark,
),
useMaterial3: true,
cardTheme: CardTheme(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
),
),
home: const LoginScreen(),
);
}
}