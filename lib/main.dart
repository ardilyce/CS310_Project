import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:project/screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/image_upload_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/text_input_screen.dart';
import 'screens/analyze_screen.dart';
import 'screens/previous_inquiries_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/analysis_results_screen.dart';
import 'screens/detailed_analysis_screen.dart';
import 'screens/extracted_text_screen.dart';
import 'screens/email_verification_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/firebase_options.dart';
import 'screens/utility_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with firebase_options.dart
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If Firebase is not configured yet, show error but don't crash
    debugPrint('⚠️ Firebase initialization error: $e');
    debugPrint(
      '📝 Please update firebase_options.dart with your Firebase project configuration',
    );
    debugPrint('📖 See FIREBASE_SETUP.md for detailed instructions');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/forget_password': (context) => const ForgotPasswordScreen(),
              '/email_verification': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return EmailVerificationScreen(email: args['email']);
              },
              '/image_upload': (context) => const ImageUploadScreen(),
              '/extracted_text': (context) => const ExtractedTextScreen(),
              '/home': (context) => const HomeScreen(),
              '/learn': (context) => const LearnScreen(),
              '/text_input': (context) => const TextInputScreen(),
              '/analyze': (context) => const AnalyzeScreen(),
              '/previous_inquiries': (context) => const PreviousInquiriesScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/results': (context) => const AnalysisResultsScreen(),
              '/details': (context) => DetailedAnalysisScreen(),
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Poppins",
      scaffoldBackgroundColor: AppUtility.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppUtility.lightPrimaryBlue,
        secondary: AppUtility.lightSecondaryBlue,
        background: AppUtility.lightBackground,
        surface: AppUtility.lightSecondaryBlue,
        onPrimary: Colors.white,
        onSecondary: AppUtility.lightTextDark,
        onBackground: AppUtility.lightTextDark,
        onSurface: AppUtility.lightTextDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppUtility.lightPrimaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Poppins",
      scaffoldBackgroundColor: AppUtility.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppUtility.darkPrimaryBlue,
        secondary: AppUtility.darkSecondaryBlue,
        background: AppUtility.darkBackground,
        surface: AppUtility.darkSecondaryBlue,
        onPrimary: Colors.white,
        onSecondary: AppUtility.darkTextDark,
        onBackground: AppUtility.darkTextDark,
        onSurface: AppUtility.darkTextDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppUtility.darkPrimaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }
}

// Important Note //
/*
he InquiryDetailsScreen is NOT to be added to the routes
 */
