import 'package:flutter/material.dart';
import 'utility_class.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static final List<_Tip> _tips = [
    _Tip(
      title: '1. How to Spot a Phishing Email',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur posuere.',
    ),
    _Tip(
      title: '2. Email Scams',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur posuere.',
    ),
    _Tip(
      title: '3. SMS / WhatsApp Scams',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    ),
    _Tip(
      title: '5. Impersonation',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet ligula et nunc faucibus porta.',
    ),
    _Tip(
      title: '6. Dangerous Websites',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet ligula et nunc faucibus porta. Vivamus eget quam nec arcu facilisis suscipit non ac lacus. Curabitur id lorem ut est gravida feugiat sed vel elit.',
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
