import 'package:flutter/material.dart';
import 'utility_class.dart';

// Model class
class AnalysisItem {
  final String title;
  final String points;
  AnalysisItem(this.title, this.points);
}

class DetailedAnalysisScreen extends StatelessWidget {
  
  // We hardcode the score here for the demo, you can change it to test different colors
  final int score = 70;

  // List Data, will be captured form another file after PhishGuard algorithm runs, these are placeholders
  final List<AnalysisItem> _items = [
    AnalysisItem("Suspicious Keywords: 'urgent', 'reset'", "+25"),
    AnalysisItem("High suspicious word ratio", "+10"),
    AnalysisItem("Shortened Link detected", "+20"),
    AnalysisItem("Excessive ALL CAPS Usage", "+10"),
    AnalysisItem("Excessive Exclamation Mark Usage", "+5"),
  ];

  @override
  Widget build(BuildContext context) {
    final Color riskColor = AppUtility.getColorForScore(score);
    final String risk = AppUtility.getRiskForScore(score);

    return Scaffold(
      backgroundColor: AppUtility.background,
      appBar: AppBar(
        title: Text(
          "Detailed Analysis",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppUtility.primaryBlue,
        foregroundColor: Colors.white,
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
          // Small Header
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
          Divider(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Score Evaluation:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Divider(height: 20, indent: 20, endIndent: 20),
          // List of score contributors
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
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
                        _items[index].title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        _items[index].points,
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
                        color: Colors.white,
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
