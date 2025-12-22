import 'package:flutter/material.dart';
import 'utility_class.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static final List<_Tip> _tips = [
    _Tip(
      title: '1. How to Spot a Phishing Email',
      description:
          'Be careful with emails that create urgency, like saying your account will be closed. Check the sender’s email address carefully, look for spelling mistakes, and never click links or download files unless you are 100% sure the email is real.',
    ),
    _Tip(
      title: '2. Email Scams',
      description:
          'Scam emails often pretend to be from banks, delivery services, or social media platforms. They may ask you to verify your account or reset your password. Real companies usually do not ask for sensitive information by email.',
    ),
    _Tip(
      title: '3. SMS / WhatsApp Scams',
      description:
          'Scam messages may include suspicious links, prizes, or warnings about blocked accounts. Do not click links from unknown numbers, and never share one-time codes or personal information through messages.',
    ),
    _Tip(
      title: '5. Impersonation',
      description:
          'Attackers may pretend to be a friend, a coworker, or customer support. If someone asks for money, passwords, or codes, verify their identity using another method, such as calling them directly.',
    ),
    _Tip(
      title: '6. Dangerous Websites',
      description:
          'Avoid websites that look strange, have many pop-ups, or do not use HTTPS. Always check the website address carefully, especially before entering passwords or payment details. Fake websites often look similar to real ones.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUtility.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppUtility.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tips and Lessons',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppUtility.textWhite,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.lightbulb_outline, color: AppUtility.textWhite),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppUtility.background,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: [
            Text(
              'Learn & Stay Safe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppUtility.textDark,
              ),
            ),
            const SizedBox(height: 24),
            ..._tips.asMap().entries.map((entry) {
              final index = entry.key;
              final tip = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppUtility.secondaryBlue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppUtility.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tip.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppUtility.textDark,
                          height: 1.4,
                        ),
                      ),

                      // 👇 Only show image in first tip
                      if (index == 0) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "https://timely-benefit-e63d540317.media.strapiapp.com/sample_phishing_email_includes_an_unusual_sender_email_address_90ef8c4234.jpg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Tip {
  final String title;
  final String description;

  const _Tip({required this.title, required this.description});
}
