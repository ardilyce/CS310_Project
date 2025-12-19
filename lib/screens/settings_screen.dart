import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'utility_class.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _keepHistory = true;

  @override
  Widget build(BuildContext context) {
    // not super clean layout but works
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppUtility.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Dark Mode row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 60,
              decoration: BoxDecoration(
                color: AppUtility.secondaryBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppUtility.textDark,
                    ),
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Switch(
                        value: themeProvider.isDarkMode,
                        activeColor: Colors.white,
                        activeTrackColor: AppUtility.primaryBlue,
                        onChanged: (value) {
                          themeProvider.setDarkMode(value);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Keep History row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 60,
              decoration: BoxDecoration(
                color: AppUtility.secondaryBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Keep History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppUtility.textDark,
                    ),
                  ),
                  Switch(
                    value: _keepHistory,
                    activeColor: Colors.white,
                    activeTrackColor: AppUtility.primaryBlue,
                    onChanged: (value) {
                      setState(() {
                        _keepHistory = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Clear History button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // will add actual clear later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clear history will come soon.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtility.secondaryBlue,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Clear History',
                  style: TextStyle(
                    color: AppUtility.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            // Show confirmation dialog
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true && context.mounted) {
                              await authProvider.signOut();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (route) => false,
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppUtility.secondaryBlue,
                      disabledBackgroundColor: Colors.grey,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Logout',
                            style: TextStyle(
                              color: AppUtility.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),

          // push the rest to bottom
          const Spacer(),

          // bottom section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 4),
                Text(
                  'Account Settings',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppUtility.textGrey,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // delete later (danger!)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delete account will come soon.'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB00000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: AppUtility.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
