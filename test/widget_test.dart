import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/screens/analysis_results_screen.dart';
import 'package:project/screens/detailed_analysis_screen.dart';
import 'package:project/services/analysis_service.dart';

void main() {
  testWidgets('AnalysisResultsScreen shows score and risk label', (tester) async {
    final result = AnalysisResult(
      score: 42,
      riskLevel: 'Medium Risk',
      breakdown: [AnalysisItem('Suspicious Keywords (2 found)', '+20')],
      originalText: 'Test message',
    );

    await tester.pumpWidget(
      MaterialApp(home: AnalysisResultsScreen(result: result)),
    );

    expect(find.text('Analysis Results'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('Medium Risk'), findsOneWidget);
  });

  testWidgets('AnalysisResultsScreen navigates to DetailedAnalysisScreen', (tester) async {
    final result = AnalysisResult(
      score: 55,
      riskLevel: 'Medium Risk',
      breakdown: [AnalysisItem('Link/URL Detected', '+20')],
      originalText: 'Test message',
    );

    await tester.pumpWidget(
      MaterialApp(home: AnalysisResultsScreen(result: result)),
    );

    await tester.tap(find.text('Detailed Analysis'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailedAnalysisScreen), findsOneWidget);
    expect(find.text('Detailed Analysis'), findsOneWidget);
  });

  testWidgets('DetailedAnalysisScreen shows empty state when no items', (tester) async {
    final result = AnalysisResult(
      score: 5,
      riskLevel: 'No Risk',
      breakdown: const [],
      originalText: 'Safe message',
    );

    await tester.pumpWidget(
      MaterialApp(home: DetailedAnalysisScreen(result: result)),
    );

    expect(find.text('No suspicious elements found.'), findsOneWidget);
  });

  testWidgets('DetailedAnalysisScreen navigates to previous inquiries route', (tester) async {
    final result = AnalysisResult(
      score: 40,
      riskLevel: 'Medium Risk',
      breakdown: [AnalysisItem('Link/URL Detected', '+20')],
      originalText: 'Test message',
    );

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/previous_inquiries': (context) => const Scaffold(
                body: Text('Previous Inquiries Screen'),
              ),
        },
        home: DetailedAnalysisScreen(result: result),
      ),
    );

    await tester.tap(find.text('See Previous Results'));
    await tester.pumpAndSettle();

    expect(find.text('Previous Inquiries Screen'), findsOneWidget);
  });
}
