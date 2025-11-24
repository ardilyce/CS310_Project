import 'package:flutter/material.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 1 second and navigate to the analysis results screen
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/results');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Using a gradient to match the background in the image
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF022047), // dark blue
              Color(0xFF0A4DBA), // light blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 130,
                height: 130,
              ),

              const SizedBox(height: 24),

              // The "Analyzing..." text
              const Text(
                "Analyzing...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              // The circular loading indicator
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5, // Make the line a bit thicker
              ),
            ],
          ),
        ),
      ),
    );
  }
}
