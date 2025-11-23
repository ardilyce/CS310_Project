

class Inquiry {

  String id;
  DateTime date;
  int score;
  String? message;

  Inquiry(this.id, this.date, this.score, this.message) {}

  String inquiryDateGen() {
    // MM/DD/YYyy

    return (date.month < 10 ? '0' + date.month.toString() : date.month.toString())
        + '/'
        + (date.day < 10 ? '0' + date.day.toString() : date.day.toString())
        + '/'
        + date.year.toString().substring(2);
  }

  // Factory Method for Testing purposes
  factory Inquiry.mock({required String id, required int score, required String content, required DateTime date}) {
    return Inquiry(id, date, score, content);
  }

}





//////// MOCK INQURIES FOR TESTING ///////////

final List<Inquiry> mockInquiries = [
  Inquiry.mock(
    id: '80',
    date: DateTime(2025, 11, 23),
    score: 80,
    content: "URGENT: Your bank account has been flagged for unusual activity. Click here immediately to verify your credentials and avoid service disruption. Failure to act within 2 hours will result in permanent account suspension.",
  ),
  Inquiry.mock(
    id: '71',
    date: DateTime(2025, 11, 22),
    score: 71,
    content: "Congratulations! You have been selected as a winner in our latest contest. Follow the link to claim your prize of \$1,000,000. Do not share this link with anyone. Limited time offer.",
  ),
  Inquiry.mock(
    id: '12',
    date: DateTime(2025, 11, 21),
    score: 12,
    content: "Reminder: Your subscription to 'Tech News Daily' will renew on December 1st. No action is required if you wish to continue. Thank you for being a valued customer.",
  ),
  Inquiry.mock(id: '32', date: DateTime(2025, 11, 20), score: 32, content: "Update to our privacy policy is available now. Please review the changes at your convenience. This is a standard notification."),
  Inquiry.mock(id: '83', date: DateTime(2025, 11, 19), score: 83, content: "You have a new security alert! Someone from an unknown location has logged into your email. If this was not you, click this link to secure your account NOW!"),
  Inquiry.mock(id: '44', date: DateTime(2025, 11, 18), score: 44, content: "Your order #48572 is being processed and will ship soon. We will notify you with a tracking number once it leaves the warehouse. Thank you for your business."),
  // ... more mock data
];
