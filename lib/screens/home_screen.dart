import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'previous_inquiries_screen.dart';
import '../providers/theme_provider.dart';
import 'utility_class.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: AppUtility.primaryBlue,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                color: AppUtility.background,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppUtility.textDark,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _DashboardButton(
                        icon: Icons.description_outlined,
                        label: 'Paste\nText',
                        onTap: () => Navigator.pushNamed(context, '/text_input'),
                      ),
                      const SizedBox(height: 24),
                      _DashboardButton(
                        icon: Icons.photo_camera_outlined,
                        label: 'Scan\nPhoto',
                        onTap: () =>
                            Navigator.pushNamed(context, '/image_upload'),
                      ),
                      const SizedBox(height: 32),
                      Divider(
                        color: AppUtility.primaryBlue.withOpacity(0.4),
                        thickness: 4,
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/learn'),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppUtility.secondaryBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: AppUtility.primaryBlue,
                                size: 32,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Learn & Stay Safe',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppUtility.textDark,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Quick tips to identify scams',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppUtility.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppUtility.primaryBlue,
                              ),
                            ],
                          ),
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
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      color: AppUtility.primaryBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/logo.png", width: 44, height: 44),
              const SizedBox(width: 16),
              Text(
                'PhishGuard',
                style: TextStyle(
                  color: AppUtility.textWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final double iconSize = 28;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
      decoration: BoxDecoration(
        color: AppUtility.primaryBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreviousInquiriesScreen(),
                ),
              );
            },
            icon: Icon(Icons.access_time, color: AppUtility.textWhite),
            iconSize: iconSize,
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppUtility.background,
              borderRadius: BorderRadius.circular(30),
            ),
            child:
                Icon(Icons.home, color: AppUtility.primaryBlue, size: iconSize),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: Icon(Icons.settings, color: AppUtility.textWhite),
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppUtility.secondaryBlue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: AppUtility.primaryBlue),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppUtility.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
