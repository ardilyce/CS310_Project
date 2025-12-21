import 'package:flutter/foundation.dart';
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

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  
  // Expose auth state changes stream for real-time route protection
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  AuthProvider() {
    debugPrint('🔧 AuthProvider initialized');
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('🔄 AUTH STATE CHANGED');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('👤 User: ${user?.email ?? "null"}');
      debugPrint('   - UID: ${user?.uid ?? "null"}');
      debugPrint('   - Previous user: ${_user?.email ?? "null"}');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');
      
      _user = user;
      notifyListeners();
      
      debugPrint('✅ Auth state updated and listeners notified');
      debugPrint('═══════════════════════════════════════════════════════════');
    });
    debugPrint('✅ Auth state listener registered');
  }

  // Sign up - creates user and stores data in Firestore
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    try {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('📝 SIGN UP STARTED');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('📧 Email: $email');
      debugPrint('👤 Name: $name');
      debugPrint('🎂 Age: $age');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');
      
      _setLoading(true);
      _clearError();
      
      // Create Firebase Auth user
      debugPrint('🔑 Creating Firebase Auth user...');
      UserCredential? userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential == null) {
        debugPrint('❌ Failed to create Firebase Auth user (null credential)');
        _setError('Failed to create account. Please try again.');
        _setLoading(false);
        notifyListeners();
        debugPrint('═══════════════════════════════════════════════════════════');
        debugPrint('❌ SIGN UP FAILED - NULL CREDENTIAL');
        debugPrint('═══════════════════════════════════════════════════════════');
        return false;
      }

      debugPrint('✅ Firebase Auth user created:');
      debugPrint('   - UID: ${userCredential.user?.uid}');
      debugPrint('   - Email: ${userCredential.user?.email}');
      
      _user = userCredential.user;

      // Store user data in Firestore
      if (_user != null && _user!.uid.isNotEmpty) {
        debugPrint('💾 Storing user data in Firestore...');
        await _databaseService.storeUserData(
          userId: _user!.uid,
          email: email,
          name: name,
          age: age,
        );
        debugPrint('✅ User data stored');
      }
      
      _setLoading(false);
      notifyListeners();
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('🎉 SIGN UP SUCCESS');
      debugPrint('═══════════════════════════════════════════════════════════');
      return true;
    } catch (e, stackTrace) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('❌ SIGN UP ERROR');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('❌ Error: $e');
      debugPrint('📚 Stack trace:');
      debugPrint(stackTrace.toString());
      
      // Delete Firebase Auth user if it was created
      try {
        if (_user != null) {
          await _user?.delete();
          _user = null;
        }
      } catch (cleanupError) {
        debugPrint('⚠️ Failed to cleanup Firebase Auth user: $cleanupError');
      }
      
      // Extract error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      
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
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('🔐 SIGN IN STARTED');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('📧 Email: $email');
      debugPrint('⏰ Timestamp: ${DateTime.now()}');
      
      _setLoading(true);
      _clearError();
      
      debugPrint('🔑 Attempting to sign in with Firebase Auth...');
      UserCredential? userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        debugPrint('✅ Sign in successful!');
        debugPrint('   - User UID: ${userCredential.user?.uid}');
        debugPrint('   - User email: ${userCredential.user?.email}');
        
        _user = userCredential.user;
        
        _setLoading(false);
        notifyListeners();
        debugPrint('═══════════════════════════════════════════════════════════');
        debugPrint('🎉 SIGN IN SUCCESS');
        debugPrint('═══════════════════════════════════════════════════════════');
        return true;
      }
      
      debugPrint('❌ Sign in returned null userCredential');
      _setLoading(false);
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('❌ SIGN IN FAILED - NULL CREDENTIAL');
      debugPrint('═══════════════════════════════════════════════════════════');
      return false;
    } catch (e, stackTrace) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('❌ SIGN IN ERROR');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('❌ Error: $e');
      debugPrint('📚 Stack trace:');
      debugPrint(stackTrace.toString());
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
}
