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

  // Initialize theme provider and load saved preference
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider? themeProvider;
  
  const MyApp({super.key, this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => themeProvider ?? ThemeProvider(),
        ),
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
            // Use onGenerateRoute for route protection
            onGenerateRoute: (settings) {
              return _generateRoute(settings, themeProvider);
            },
            // Keep routes for backward compatibility (but onGenerateRoute takes precedence)
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/forget_password': (context) => const ForgotPasswordScreen(),
            },
          );
        },
      ),
    );
  }

  // Route generator with authentication protection
  Route<dynamic> _generateRoute(RouteSettings settings, ThemeProvider themeProvider) {
    // Public routes (accessible without authentication)
    final publicRoutes = [
      '/splash',
      '/login',
      '/signup',
      '/forget_password',
    ];

    // Protected routes (require authentication)
    final protectedRoutes = [
      '/home',
      '/settings',
      '/previous_inquiries',
      '/text_input',
      '/image_upload',
      //'/analyze',
      //'/results',
      //'/details',
      '/extracted_text',
      '/learn',
    ];

    // Check if route is public
    if (publicRoutes.contains(settings.name)) {
      return _buildRoute(settings, themeProvider);
    }

    // Check if route is protected
    if (protectedRoutes.contains(settings.name)) {
      return MaterialPageRoute(
        builder: (context) {
          // Use Consumer to access AuthProvider and StreamBuilder for real-time updates
          return Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return StreamBuilder(
                stream: authProvider.authStateChanges,
                builder: (context, snapshot) {
                  // Show loading while checking auth state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final user = snapshot.data;

                  // If user is not authenticated, redirect to login
                  if (user == null || !authProvider.isAuthenticated) {
                    // Use WidgetsBinding to ensure navigation happens after build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      }
                    });
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // User is authenticated, show the protected route
                  return _buildWidgetForRoute(settings.name ?? '/home');
                },
              );
            },
          );
        },
      );
    }

    // Unknown route, redirect to splash
    return MaterialPageRoute(
      builder: (context) => const SplashScreen(),
    );
  }

  // Build widget for route (used in StreamBuilder)
  Widget _buildWidgetForRoute(String? routeName) {
    switch (routeName) {
      case '/home':
        return const HomeScreen();
      case '/settings':
        return const SettingsScreen();
      case '/previous_inquiries':
        return const PreviousInquiriesScreen();
      case '/text_input':
        return const TextInputScreen();
      case '/image_upload':
        return const ImageUploadScreen();
      //case '/analyze':
      //  return const AnalyzeScreen();
      //case '/results':
      //  return const AnalysisResultsScreen();
      //case '/details':
      //  return DetailedAnalysisScreen();
      case '/extracted_text':
        return const ExtractedTextScreen();
      case '/learn':
        return const LearnScreen();
      default:
        return const HomeScreen();
    }
  }

  // Build route based on route name
  Route<dynamic> _buildRoute(RouteSettings settings, ThemeProvider themeProvider) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/forget_password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/previous_inquiries':
        return MaterialPageRoute(builder: (_) => const PreviousInquiriesScreen());
      case '/text_input':
        return MaterialPageRoute(builder: (_) => const TextInputScreen());
      case '/image_upload':
        return MaterialPageRoute(builder: (_) => const ImageUploadScreen());
      //case '/analyze':
      //  return MaterialPageRoute(builder: (_) => const AnalyzeScreen());
      //case '/results':
      //  return MaterialPageRoute(builder: (_) => const AnalysisResultsScreen());
      //case '/details':
      //  return MaterialPageRoute(builder: (_) => DetailedAnalysisScreen());
      case '/extracted_text':
        return MaterialPageRoute(builder: (_) => const ExtractedTextScreen());
      case '/learn':
        return MaterialPageRoute(builder: (_) => const LearnScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
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
Also, analyze, analysis results and detailed analysis are also removed due to them requiring parameters
in their constructors, and they shouldn't be accessed from pages that aren't right before them anyway
 */
