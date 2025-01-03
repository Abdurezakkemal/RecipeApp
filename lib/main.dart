import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/Provider/favorite_provider.dart';
import 'package:recipeapp/Provider/quantity.dart';
import 'package:recipeapp/Provider/settings_provider.dart';
import 'package:recipeapp/Views/app_main_screen.dart';
import 'package:recipeapp/Views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipeapp/Provider/meal_plan_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp( const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
        // ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
      ],
      
      child: MaterialApp(
  theme: ThemeData.light().copyWith(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
    ),
  ),
  darkTheme: ThemeData.dark().copyWith(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
    ),
  ),
  themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
  debugShowCheckedModeBanner: false,
  home: const AuthWrapper(),
)

    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in, if yes, navigate to the main screen.
    return user != null ? const AppMainScreen() : const LoginScreen();
  }
}
