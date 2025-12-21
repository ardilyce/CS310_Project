// This is the PhishGuard algorithm that calculates the risk score for a given text
class AnalysisItem {
  final String title;
  final String points;

  AnalysisItem(this.title, this.points);

  // Helper to save this object to Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'points': points,
    };
  }
}

class AnalysisResult {
  final int score;
  final String riskLevel;
  final List<AnalysisItem> breakdown;
  final String originalText; // We keep the text here to pass it around easily

  AnalysisResult({
    required this.score,
    required this.riskLevel,
    required this.breakdown,
    required this.originalText,
  });
}

class AnalysisService {
  static AnalysisResult analyzeText(String text) {
    int score = 0;
    List<AnalysisItem> items = [];
    String lowerText = text.toLowerCase();

    // Keyword Detection
    List<String> keywords = ['urgent', 'verify', 'account', 'suspended', 'password', 'bank', 'winner', 'reset'];
    int keywordCount = 0;
    for (String word in keywords) {
      if (lowerText.contains(word)) {
        keywordCount++;
      }
    }
    if (keywordCount > 0) {
      int points = keywordCount * 10;
      score += points;
      items.add(AnalysisItem("Suspicious Keywords ($keywordCount found)", "+$points"));
    }

    // Link Detection
    if (lowerText.contains("http") || lowerText.contains("www") || lowerText.contains(".com")) {
      score += 20;
      items.add(AnalysisItem("Link/URL Detected", "+20"));
    }

    // Urgency Check
    if (text.contains("!!!") ) {
      score += 10;
      items.add(AnalysisItem("Aggressive Urgency", "+10"));
    }

    // Excessive Upper Case Check
    if (text.toUpperCase() == text && text.length > 10) {
      score += 10;
      items.add(AnalysisItem("Excessive All Caps", "+10"));
    }

    // Very short text
    if (text.length < 20) {
      score += 5;
      items.add(AnalysisItem("Message is unusually short", "+5"));
    }

    // Max score is 100
    if (score > 100) score = 100;

    // Determine Risk Level Label
    String risk = "No Risk";
    if (score > 25 && score < 51) { risk = "Low Risk"; }
    else if (score > 50 && score < 76) { risk = "Medium Risk"; }
    else if (score > 75 && score < 101) { risk = "High Risk"; }

    return AnalysisResult(
        score: score,
        riskLevel: risk,
        breakdown: items,
        originalText: text
    );
  }
}