import 'package:flutter_test/flutter_test.dart';
import 'package:project/screens/utility_class.dart';

void main() {
  test('getColorForScore returns green for scores up to 15', () {
    expect(AppUtility.getColorForScore(0), AppUtility.riskGreen);
    expect(AppUtility.getColorForScore(15), AppUtility.riskGreen);
  });

  test('getColorForScore returns correct colors for thresholds', () {
    expect(AppUtility.getColorForScore(16), AppUtility.riskYellow);
    expect(AppUtility.getColorForScore(30), AppUtility.riskYellow);
    expect(AppUtility.getColorForScore(31), AppUtility.riskOrange);
    expect(AppUtility.getColorForScore(70), AppUtility.riskOrange);
    expect(AppUtility.getColorForScore(71), AppUtility.riskRed);
  });
}
