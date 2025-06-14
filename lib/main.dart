import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ملف الإعدادات اللي اتولد بعد flutterfire configure
import 'screens/welcome_screen.dart';
import 'screens/client_registration_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/passport_search_screen.dart';
import 'screens/ClientNationalIdScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solidere Misr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/clientRegistration': (context) => ClientRegistrationScreen(),
        '/clientLogin': (context) => ClientNationalIdScreen(),
        '/adminLogin': (context) => AdminLoginScreen(),
        '/adminHome': (context) => AdminHomeScreen(),
        '/passportSearch': (context) => PassportSearchScreen(),
      },
    );
  }
}
