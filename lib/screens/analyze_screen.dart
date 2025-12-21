import 'package:flutter/material.dart';
import 'utility_class.dart';
import '../services/analysis_service.dart'; // Import the service
import 'analysis_results_screen.dart';     // Import the next screen

class AnalyzeScreen extends StatefulWidget {
  // 1. Accept the result in the constructor
  final AnalysisResult result;

  const AnalyzeScreen({super.key, required this.result});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  @override
  void initState() {
    super.initState();
    // 2. Wait 2 seconds, then navigate manually
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // Pass 'widget.result' to the next screen
            builder: (context) => AnalysisResultsScreen(result: widget.result),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your existing UI code remains exactly the same...
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppUtility.thirdBlue, AppUtility.primaryBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", width: 130, height: 130),
              const SizedBox(height: 24),
              Text("Analyzing...",
                  style: TextStyle(color: AppUtility.textWhite, fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 40),
              CircularProgressIndicator(color: AppUtility.textWhite, strokeWidth: 5),
            ],
          ),
        ),
      ),
    );
  }
}