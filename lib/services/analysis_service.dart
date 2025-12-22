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
    List<String> totalWordsList = text.trim().split(RegExp(r'\s+'));
    int totalWordCount = totalWordsList.length;

    // Keyword Detection
    List<String> keywords = [
      // Urgency & Action
      'urgent', 'verify', 'account', 'suspended', 'immediately', 'act now',
      'action required', 'limited time', '24 hours',

      // Rewards & Prizes
      'winner', 'prize', 'win', 'won', 'free', 'gift', 'lottery', 'reward',
      'cash', 'funds', 'claim',

      // Security & Banking
      'password', 'bank', 'reset', 'security', 'unauthorized', 'access',
      'credit card', 'debit', 'ssn', 'social security', 'pin', 'identity',
      'tax', 'refund', 'payment'
    ];
    int keywordCount = 0;
    for (String word in keywords) {
      if (lowerText.contains(word)) {
        keywordCount++;
      }
    }
    if (keywordCount > 0) {
      int points = (keywordCount * 10).clamp(0, 50);
      score += points;
      items.add(AnalysisItem("Suspicious Keywords ($keywordCount found)", "+$points"));
    }

    // Suspicious Word Ratio Check
    if (totalWordCount > 0 && keywordCount > 0) {
      double ratio = keywordCount / totalWordCount;

      // If more than 20% of the words are suspicious
      if (ratio > 0.20) {
        score += 25;
        items.add(AnalysisItem("High Density of Suspicious Words", "+25"));
      }
    }

    // Shortened URL Check
    bool url = false; // This variable is used so we don't double count short links
    List<String> shorteners = [
      'bit.ly', 'tinyurl.com', 'is.gd', 'ow.ly', 't.co', 'goo.gl',
      'rebrand.ly', 'clck.ru', 'tr.im', 'buff.ly'
    ];

    for (String shortener in shorteners) {
      if (lowerText.contains(shortener)) {
        url = true;
        score += 40;
        items.add(AnalysisItem("URL Shortener Detected ($shortener)", "+40"));
      }
    }

    // Link Detection
    if (url == false && (lowerText.contains("http") || lowerText.contains("www") || lowerText.contains(".com"))) {
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