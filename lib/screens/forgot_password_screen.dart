import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'utility_class.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.resetPassword(_emailController.text);
      
      if (success && mounted) {
        // Show success message
        setState(() {
          _emailSent = true;
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppUtility.thirdBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text(
                    "Email Sent!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                "A password reset link has been sent to ${_emailController.text}. Please check your inbox.",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    "Back to Login",
                    style: TextStyle(
                      color: AppUtility.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppUtility.thirdBlue, // dark blue
                AppUtility.primaryBlue, // light blue
              ],
            ),
          ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    const SizedBox(height: 40),

                    // Logo
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 90,
                        height: 90,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Title
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "No worries, we'll send you",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "reset instructions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Instruction text
                    const Text(
                      "Enter your email address and we will send you a link to reset your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),

                    const SizedBox(height: 30),

                    // Email field
                    const Text(
                      "E-mail",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        filled: false,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white70,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Email must contain @ symbol';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    // Error message display
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        if (authProvider.errorMessage == null) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.errorMessage ?? '',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red, size: 18),
                                onPressed: () {
                                  authProvider.clearError();
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Submit button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading ? null : _submitEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppUtility.thirdBlue,
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    "Send Reset Link",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Back to login link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white70,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Back to Login",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
