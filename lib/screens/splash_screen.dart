import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import "utility_class.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check authentication state and navigate accordingly
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Navigate based on authentication state
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // Background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppUtility.thirdBlue, AppUtility.primaryBlue],
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),

            // Logo
            Image.asset("assets/images/logo.png", width: 130, height: 130),

            const SizedBox(height: 30),

            // Title
            const Text(
              "PhishGuard",
              style: TextStyle(
                color: AppUtility.textWhite,
                fontSize: 38,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            const Text(
              "Detect scams before they catch you.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppUtility.textLight, fontSize: 18),
            ),

            const Spacer(),

            // Footer
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                "CS310 Project – Sabancı University",
                style: TextStyle(color: AppUtility.textLight2, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
