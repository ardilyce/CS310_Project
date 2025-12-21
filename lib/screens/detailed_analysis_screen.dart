import 'package:flutter/material.dart';
import 'utility_class.dart';
import '../services/analysis_service.dart';

class DetailedAnalysisScreen extends StatelessWidget {
  // The result will be received by the constructor
  final AnalysisResult result;

  const DetailedAnalysisScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final int score = result.score;
    final String risk = result.riskLevel;
    final Color riskColor = AppUtility.getColorForScore(score);

    // The breakdown of why we got this score
    final List<AnalysisItem> items = result.breakdown;

    return Scaffold(
      backgroundColor: AppUtility.background,
      appBar: AppBar(
        title: Text(
          "Detailed Analysis",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppUtility.primaryBlue,
        foregroundColor: AppUtility.textWhite,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
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

          Divider(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Score Evaluation:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppUtility.textDark,
                ),
              ),
            ),
          ),

          Divider(height: 20, indent: 20, endIndent: 20),

          Expanded(
            child: items.isEmpty
                ? Center(child: Text("No suspicious elements found."))
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      leading: Icon(
                        Icons.warning_amber_rounded,
                        color: riskColor,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppUtility.textDark,
                        ),
                      ),
                      trailing: Text(
                        item.points,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Divider(indent: 20, endIndent: 20),
                  ],
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Final Score: $score = ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppUtility.textDark,
                      ),
                    ),
                    Text(
                      risk.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppUtility.primaryBlue,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/previous_inquiries'),
                    child: Text(
                      "See Previous Results",
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
        ],
      ),
    );
  }
}