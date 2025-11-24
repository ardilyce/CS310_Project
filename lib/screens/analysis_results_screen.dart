import 'package:flutter/material.dart';
import 'utility_class.dart';

class AnalysisResultsScreen extends StatelessWidget {
  // We hardcode the score here for the demo, you can change it to test different colors
  const AnalysisResultsScreen({super.key});
  final int score = 70;

  @override
  Widget build(BuildContext context) {
    final Color riskColor = AppUtility.getColorForScore(score);
    final String risk = AppUtility.getRiskForScore(score);

    return Scaffold(
      backgroundColor: AppUtility.background,
      appBar: AppBar(
        title: Text(
          "Analysis Results",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppUtility.primaryBlue,
        foregroundColor: Colors.white,
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

            // Circular Score
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
                        backgroundColor: Colors.grey.shade200,
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
                          ),
                        ),
                        Text(
                          "/100",
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 50),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 26,
                  color: AppUtility.textDark,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: "There is a "),
                  TextSpan(
                    text: risk,
                    style: TextStyle(color: riskColor),
                  ),
                  TextSpan(text: "\nthat this message is a scam attempt."),
                ],
              ),
            ),

            SizedBox(height: 20),
            Text(
              "You can view a more detailed analysis by tapping below.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),

            Spacer(flex: 2),

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
                  Navigator.pushNamed(context, '/details');
                },
                child: Text(
                  "Detailed Analysis",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
