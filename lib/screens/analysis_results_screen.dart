import 'package:flutter/material.dart';
import 'utility_class.dart';
import '../services/analysis_service.dart';
import 'detailed_analysis_screen.dart';

class AnalysisResultsScreen extends StatelessWidget {
  // The result will be received by the constructor
  final AnalysisResult result;

  const AnalysisResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final int score = result.score;
    final String risk = result.riskLevel;
    final Color riskColor = AppUtility.getColorForScore(score);

    return Scaffold(
      backgroundColor: AppUtility.background,
      appBar: AppBar(
        title: Text(
          "Analysis Results",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppUtility.primaryBlue,
        foregroundColor: AppUtility.textWhite,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 12,
                        color: riskColor,
                        backgroundColor: AppUtility.secondaryBlue,
                      ),
                    ),
                    Icon(
                      Icons.priority_high,
                      size: 60,
                      fontWeight: FontWeight.bold,
                      color: AppUtility.textDark,
                    ),
                  ],
                ),

                SizedBox(width: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "PhishGuard Score:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: AppUtility.textDark,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "$score",
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: AppUtility.textDark,
                          ),
                        ),
                        Text(
                          "/100",
                          style: TextStyle(
                            fontSize: 24,
                            color: AppUtility.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 50),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "There is a ",
                      style: TextStyle(
                        fontSize: 26,
                        color: AppUtility.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      risk,
                      style: TextStyle(
                        fontSize: 26,
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "that this message is a scam attempt.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: AppUtility.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Text(
              "You can view a more detailed analysis by tapping below.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppUtility.textGrey),
            ),

            Spacer(flex: 2),

            // Navigation button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtility.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate passing the data to the detailed screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedAnalysisScreen(result: result),
                    ),
                  );
                },
                child: Text(
                  "Detailed Analysis",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppUtility.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}