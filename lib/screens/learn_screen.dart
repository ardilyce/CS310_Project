import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static final List<_Tip> _tips = [
    _Tip(
      title: 'How to Spot a Phishing Email',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur posuere.... --> more',
    ),
    _Tip(
      title: 'Email Scams',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur posuere.... --> more',
    ),
    _Tip(
      title: 'SMS / WhatsApp Scams',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur posuere.... --> more',
    ),
    _Tip(
      title: 'Impersonation',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur posuere.... --> more',
    ),
    _Tip(
      title: 'Dangerous Websites',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet ligula et nunc faucibus porta. Vivamus eget quam nec arcu facilisis suscipit non ac lacus. Curabitur id lorem ut est gravida feugiat sed vel elit.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4DBA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Tips and Lessons',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: [
            const Text(
              'Learn & Stay Safe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            ..._tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFECFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tip.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
