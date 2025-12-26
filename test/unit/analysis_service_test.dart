import 'package:flutter_test/flutter_test.dart';
import 'package:project/services/analysis_service.dart';

void main() {
  test('analyzeText flags a high risk message with keywords and a shortener', () {
    final result = AnalysisService.analyzeText(
      'URGENT VERIFY ACCOUNT SUSPENDED PASSWORD BANK bit.ly!!!',
    );

    expect(result.score, 100);
    expect(result.riskLevel, 'High Risk');
  });

  test('analyzeText returns no risk for a neutral message', () {
    final result = AnalysisService.analyzeText(
      'Reminder: your subscription renews on December 1st. No action is required.',
    );

    expect(result.score, 0);
    expect(result.riskLevel, 'No Risk');
  });

  test('analyzeText adds points for all caps and short length', () {
    final result = AnalysisService.analyzeText('THIS IS A TEST');

    expect(result.score, 15);
    expect(result.riskLevel, 'No Risk');
  });

  test('analyzeText detects a normal URL when no shortener is present', () {
    final result = AnalysisService.analyzeText(
      'Please visit http://example.com for details.',
    );

    expect(result.score, 20);
    expect(result.riskLevel, 'Low Risk');
  });
}
