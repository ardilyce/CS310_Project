import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/inquiry.dart';

void main() {
  test('inquiryDateGen formats with leading zeros and two-digit year', () {
    final inquiry = Inquiry('1', DateTime(2025, 1, 9), 10, 'Test');

    expect(inquiry.inquiryDateGen(), '01/09/25');
  });

  test('mock factory assigns core fields', () {
    final date = DateTime(2024, 12, 31);
    final inquiry = Inquiry.mock(
      id: '42',
      score: 75,
      content: 'Example content',
      date: date,
    );

    expect(inquiry.id, '42');
    expect(inquiry.score, 75);
    expect(inquiry.message, 'Example content');
    expect(inquiry.date, date);
  });
}
