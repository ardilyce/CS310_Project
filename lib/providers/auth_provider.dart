import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _requiresRecentLogin = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get requiresRecentLogin => _requiresRecentLogin;
  
  // Expose auth state changes stream for real-time route protection
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  String _extractErrorMessage(Object error) {
    String message = error.toString();
    if (message.startsWith('Exception: ')) {
      message = message.substring(11);
    }
    return message;
  }

  // Sign up - creates user and stores data in Firestore
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Create Firebase Auth user
      UserCredential? userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential == null) {
        _setError('Failed to create account. Please try again.');
        _setLoading(false);
        notifyListeners();
        return false;
      }
      
      _user = userCredential.user;

      // Store user data in Firestore
      if (_user != null && _user!.uid.isNotEmpty) {
        await _databaseService.storeUserData(
          userId: _user!.uid,
          email: email,
          name: name,
          age: age,
        );
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      // Delete Firebase Auth user if it was created
      try {
        if (_user != null) {
          await _user?.delete();
          _user = null;
        }
      } catch (cleanupError) {
        // Silently handle cleanup errors
      }
      
      // Extract error message
      String errorMessage = _extractErrorMessage(e);
      
      _setError(errorMessage);
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
      // Extract the error message from the exception
      String errorMessage = _extractErrorMessage(e);
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
      // Extract the error message from the exception
      String errorMessage = _extractErrorMessage(e);
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

  
  // Clear History
  Future<bool> clearHistory() async {
    if (_user == null) return false;
    try {
      _setLoading(true);
      await _databaseService.clearUserHistory(_user!.uid);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Delete Account
  Future<bool> deleteAccount() async {
    if (_user == null) return false;
    try {
      _setLoading(true);
      String uid = _user!.uid;

      // 1. Delete Firestore data
      await _databaseService.deleteUserData(uid);

      // 2. Delete Auth user
      await _user!.delete();

      _user = null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Please re-log in before deleting your account for security.");
      _setLoading(false);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_user == null) return null;
    try {
      return await _databaseService.getUserData(_user!.uid);
    } catch (e) {
      _setError(_extractErrorMessage(e));
      return null;
    }
  }

  Future<bool> updateUserProfile({
    required String name,
    required String email,
    String? currentPassword,
  }) async {
    if (_user == null) {
      _setError('You are not signed in. Please log in again.');
      return false;
    }
    try {
      _setLoading(true);
      _clearError();
      _requiresRecentLogin = false;

      final String trimmedName = name.trim();
      final String trimmedEmail = email.trim();

      if (trimmedName.isEmpty || trimmedEmail.isEmpty) {
        _setError('Name and email are required.');
        _setLoading(false);
        return false;
      }

      if (trimmedEmail != (_user?.email ?? '')) {
        if (currentPassword == null || currentPassword.isEmpty) {
          _requiresRecentLogin = true;
          _setError('Please enter your password to update your email.');
          _setLoading(false);
          return false;
        }

        final String? currentEmail = _user!.email;
        if (currentEmail == null || currentEmail.isEmpty) {
          throw 'Unable to verify your email. Please log in again.';
        }

        final credential = EmailAuthProvider.credential(
          email: currentEmail,
          password: currentPassword,
        );

        try {
          await _user!.reauthenticateWithCredential(credential);
          await _user!.updateEmail(trimmedEmail);
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case 'wrong-password':
            case 'invalid-credential':
              throw 'Incorrect password. Please try again.';
            case 'invalid-email':
              throw 'The email address is invalid.';
            case 'email-already-in-use':
              throw 'That email is already in use.';
            case 'operation-not-allowed':
              throw 'Email/password sign-in is disabled for this project.';
            case 'requires-recent-login':
              _requiresRecentLogin = true;
              throw 'Please re-enter your password to update your email.';
            case 'user-mismatch':
            case 'user-not-found':
              throw 'Please log in again before updating your email.';
            case 'network-request-failed':
              throw 'Network error. Please check your internet connection.';
            default:
              throw e.message ?? 'Failed to update email. Please try again.';
          }
        }
      }

      await _user!.updateDisplayName(trimmedName);
      await _user!.reload();
      _user = _authService.currentUser;

      await _databaseService.updateUserData(
        userId: _user!.uid,
        email: trimmedEmail,
        name: trimmedName,
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_extractErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }
}
