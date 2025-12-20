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
  bool get isEmailVerified => _user?.emailVerified ?? false;
  
  // Expose auth state changes stream for real-time route protection
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign up - stores data in Firestore as pending registration
  // Creates temporary Firebase Auth user for email verification, then signs out
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Step 1: Create temporary Firebase Auth user FIRST (required for Firestore permissions)
      // This authenticates the user so they can write to Firestore
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

      // Step 2: Store pending registration in Firestore (now authenticated, so rules allow it)
      await _databaseService.storePendingRegistration(
        email: email,
        password: password,
        name: name,
        age: age,
      );

      // Step 3: Send verification email
      if (_user != null && !_user!.emailVerified) {
        try {
          await _authService.sendEmailVerification();
        } catch (e) {
          debugPrint('⚠️ Failed to send verification email: $e');
          // Clean up: delete pending registration and Firebase Auth user if email fails
          await _databaseService.deletePendingRegistration(email);
          await _user?.delete();
          _user = null;
          _setError('Failed to send verification email. Please try again.');
          _setLoading(false);
          notifyListeners();
          return false;
        }
      }
      
      // Step 4: Sign out immediately - user cannot use account until email is verified
      await _authService.signOut();
      _user = null;
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Sign up error: $e');
      
      // Clean up: delete pending registration and Firebase Auth user if they were created
      try {
        await _databaseService.deletePendingRegistration(email);
      } catch (cleanupError) {
        debugPrint('⚠️ Failed to cleanup pending registration: $cleanupError');
      }
      
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

  // Sign in - only allows sign in if email is verified
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
        
        // Check if email is verified
        if (_user != null && !_user!.emailVerified) {
          // Sign out if email is not verified
          await _authService.signOut();
          _user = null;
          _setError('Please verify your email before signing in. Check your inbox for the verification link.');
          _setLoading(false);
          notifyListeners();
          return false;
        }
        
        // If email is verified, complete registration if not already done
        if (_user != null && _user!.emailVerified) {
          await _completeRegistrationAfterVerification(_user!);
        }
        
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
  // If no user is signed in, signs in temporarily with pending registration to send email
  Future<bool> sendVerificationEmail({String? email}) async {
    try {
      _setLoading(true);
      _clearError();
      
      User? currentUser = _authService.currentUser;
      bool wasSignedIn = currentUser != null;
      
      // If no user is signed in, try to sign in with pending registration
      if (!wasSignedIn && email != null) {
        final pendingData = await _databaseService.getPendingRegistration(email);
        if (pendingData != null) {
          try {
            UserCredential? userCredential = await _authService.signInWithEmailAndPassword(
              email: pendingData['email'],
              password: pendingData['password'],
            );
            if (userCredential != null) {
              currentUser = userCredential.user;
            }
          } catch (e) {
            debugPrint('❌ Failed to sign in for resending verification: $e');
            _setError('Failed to resend verification email. Please try signing up again.');
            _setLoading(false);
            notifyListeners();
            return false;
          }
        } else {
          _setError('No pending registration found. Please sign up again.');
          _setLoading(false);
          notifyListeners();
          return false;
        }
      }
      
      if (currentUser == null) {
        _setError('Unable to send verification email. Please try signing up again.');
        _setLoading(false);
        notifyListeners();
        return false;
      }
      
      await _authService.sendEmailVerification();
      
      // If we signed in temporarily, sign out again
      if (!wasSignedIn) {
        await _authService.signOut();
        _user = null;
      }
      
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

  // Check email verification status and complete registration if verified
  // This method is called from the email verification screen
  Future<bool> checkEmailVerified({String? email}) async {
    try {
      // Check if there's a current user (they might have signed in after clicking verification link)
      User? currentUser = _authService.currentUser;
      
      if (currentUser != null) {
        // Reload to get latest verification status
        await _authService.reloadUser();
        currentUser = _authService.currentUser;
        
        if (currentUser != null && currentUser.emailVerified) {
          // Email is verified - complete the registration
          await _completeRegistrationAfterVerification(currentUser);
          _user = currentUser;
          notifyListeners();
          return true;
        }
      }
      
      // If no user is signed in but we have an email, try to sign in with pending registration
      // This handles the case where user verifies email via link but isn't signed in
      if (email != null && currentUser == null) {
        final pendingData = await _databaseService.getPendingRegistration(email);
        
        if (pendingData != null) {
          // Try to sign in to check if email is verified
          try {
            UserCredential? userCredential = await _authService.signInWithEmailAndPassword(
              email: pendingData['email'],
              password: pendingData['password'],
            );
            
            if (userCredential != null) {
              await _authService.reloadUser();
              User? user = _authService.currentUser;
              
              if (user != null && user.emailVerified) {
                await _completeRegistrationAfterVerification(user);
                _user = user;
                notifyListeners();
                return true;
              } else {
                // Email not verified yet, sign out
                await _authService.signOut();
              }
            }
          } catch (e) {
            debugPrint('❌ Failed to check verification status: $e');
          }
        }
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('❌ Check email verification error: $e');
      return false;
    }
  }

  // Complete registration after email verification
  // Creates user record in database and cleans up pending registration
  Future<void> _completeRegistrationAfterVerification(User user) async {
    try {
      if (user.email == null) {
        throw 'User email is null';
      }

      // Get pending registration data
      final pendingData = await _databaseService.getPendingRegistration(user.email!);
      
      if (pendingData != null) {
        // Mark pending registration as verified
        await _databaseService.completeRegistration(user.email!);
        
        // Store user data in users collection (this is when the account is actually created)
        await _databaseService.storeUserData(
          userId: user.uid,
          email: user.email!,
          name: pendingData['name'],
          age: pendingData['age'],
        );
        
        // Delete pending registration
        await _databaseService.deletePendingRegistration(user.email!);
      }
    } catch (e) {
      debugPrint('❌ Failed to complete registration: $e');
      // Don't throw - allow user to proceed even if database update fails
      // The Firebase Auth user is already created and verified
    }
  }
}
