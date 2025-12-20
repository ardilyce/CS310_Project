import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isEmailVerified => _user?.emailVerified ?? false;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      UserCredential? userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        _user = userCredential.user;
        // Send verification email after sign up
        if (_user != null && !_user!.emailVerified) {
          try {
            await _authService.sendEmailVerification();
          } catch (e) {
            debugPrint('⚠️ Failed to send verification email: $e');
            // Don't fail sign up if verification email fails
          }
        }
        _setLoading(false);
        notifyListeners();
        return true;
      }
      
      _setLoading(false);
      return false;
    } catch (e) {
      debugPrint('❌ Sign up error: $e');
      _setError(e.toString());
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      UserCredential? userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        _user = userCredential.user;
        _setLoading(false);
        notifyListeners();
        return true;
      }
      
      _setLoading(false);
      return false;
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      // Extract the error message from the exception
      String errorMessage = e.toString();
      // Remove "Exception: " prefix if present
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      // Handle all credential-related errors with a simple, user-friendly message
      String lowerMessage = errorMessage.toLowerCase();
      if (lowerMessage.contains('wrong-password') || 
          lowerMessage.contains('wrong password') ||
          lowerMessage.contains('invalid-credential') ||
          lowerMessage.contains('user-not-found') ||
          lowerMessage.contains('no user found') ||
          lowerMessage.contains('credential') ||
          lowerMessage.contains('incorrect') ||
          lowerMessage.contains('malformed') ||
          lowerMessage.contains('expired')) {
        errorMessage = 'Incorrect email or password.';
      } else if (lowerMessage.contains('invalid-email') || lowerMessage.contains('invalid email')) {
        errorMessage = 'The email address is invalid.';
      } else if (lowerMessage.contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else {
        // For any other authentication error, show the generic message
        errorMessage = 'Incorrect email or password.';
      }
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _user = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      notifyListeners();
    }
  }

  // Password reset
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.sendPasswordResetEmail(email);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Password reset error: $e');
      // Extract the error message from the exception
      String errorMessage = e.toString();
      // Remove "Exception: " prefix if present
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      // Handle common password reset errors
      String lowerMessage = errorMessage.toLowerCase();
      if (lowerMessage.contains('user-not-found') || 
          lowerMessage.contains('no user found')) {
        errorMessage = 'No account found with this email address.';
      } else if (lowerMessage.contains('invalid-email') || 
                 lowerMessage.contains('invalid email')) {
        errorMessage = 'The email address is invalid.';
      } else if (lowerMessage.contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (lowerMessage.contains('too-many-requests')) {
        errorMessage = 'Too many requests. Please try again later.';
      } else {
        // For any other error, show a generic message
        errorMessage = 'Failed to send reset email. Please try again.';
      }
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually (useful for UI)
  void clearError() {
    _clearError();
  }

  // Send email verification
  Future<bool> sendVerificationEmail() async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.sendEmailVerification();
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Send verification email error: $e');
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      String lowerMessage = errorMessage.toLowerCase();
      if (lowerMessage.contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (lowerMessage.contains('too-many-requests')) {
        errorMessage = 'Too many requests. Please try again later.';
      } else {
        errorMessage = 'Failed to send verification email. Please try again.';
      }
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Check email verification status
  Future<bool> checkEmailVerified() async {
    try {
      await _authService.reloadUser();
      // Update user from auth service
      _user = _authService.currentUser;
      notifyListeners();
      return _user?.emailVerified ?? false;
    } catch (e) {
      debugPrint('❌ Check email verification error: $e');
      return false;
    }
  }
}
