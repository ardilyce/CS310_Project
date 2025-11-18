import 'package:flutter/material.dart';
import 'package:project/screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/image_upload_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/text_input_screen.dart';
import 'screens/analyze_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forget_password': (context) => const ForgotPasswordScreen(),
        '/image_upload': (context) => const ImageUploadScreen(),
        '/home': (context) => const HomeScreen(),
        '/learn': (context) => const LearnScreen(),
        '/text_input': (context) => const TextInputScreen(),
        '/analyze': (context) => const AnalyzeScreen(),
      },
    );
  }
}
