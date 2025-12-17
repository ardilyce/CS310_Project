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
      _setError(e.toString());
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
      _setError(e.toString());
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

