import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store pending registration (before email verification)
  // SECURITY NOTE: Password is stored temporarily in Firestore until verification.
  // In production, consider using encryption or a different flow that doesn't require storing passwords.
  Future<void> storePendingRegistration({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    try {
      // Check if there's already a pending registration for this email
      final existing = await _firestore
          .collection('pending_registrations')
          .doc(email)
          .get();
      
      if (existing.exists) {
        // Check if it's expired
        final data = existing.data();
        if (data != null && data['expiresAt'] != null) {
          final expiresAt = (data['expiresAt'] as Timestamp).toDate();
          if (DateTime.now().isAfter(expiresAt)) {
            // Delete expired registration
            await _firestore.collection('pending_registrations').doc(email).delete();
          } else {
            // Pending registration still exists and not expired
            throw 'A registration is already pending for this email. Please check your inbox for the verification email.';
          }
        }
      }
      
      // Generate a verification token
      String verificationToken = _generateVerificationToken();
      
      // Store pending registration in Firestore
      await _firestore.collection('pending_registrations').doc(email).set({
        'email': email,
        'password': password, // SECURITY: Stored temporarily until verification
        'name': name,
        'age': age,
        'verificationToken': verificationToken,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 1)), // Expires in 1 day
        ),
        'verified': false,
      });
    } catch (e) {
      throw 'Failed to store registration data: $e';
    }
  }

  // Get pending registration by email
  Future<Map<String, dynamic>?> getPendingRegistration(String email) async {
    try {
      final doc = await _firestore
          .collection('pending_registrations')
          .doc(email)
          .get();
      
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw 'Failed to get pending registration: $e';
    }
  }

  // Verify and complete registration
  Future<void> completeRegistration(String email) async {
    try {
      // Get pending registration data
      final pendingData = await getPendingRegistration(email);
      
      if (pendingData == null) {
        throw 'No pending registration found for this email.';
      }

      // Check if already verified
      if (pendingData['verified'] == true) {
        throw 'This email has already been verified.';
      }

      // Check if expired
      final expiresAt = (pendingData['expiresAt'] as Timestamp).toDate();
      if (DateTime.now().isAfter(expiresAt)) {
        // Delete expired registration
        await _firestore
            .collection('pending_registrations')
            .doc(email)
            .delete();
        throw 'Verification link has expired. Please sign up again.';
      }

      // Mark as verified
      await _firestore
          .collection('pending_registrations')
          .doc(email)
          .update({'verified': true});
    } catch (e) {
      throw 'Failed to complete registration: $e';
    }
  }

  // Store user data after successful verification
  Future<void> storeUserData({
    required String userId,
    required String email,
    required String name,
    required int age,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'name': name,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to store user data: $e';
    }
  }

  // Delete pending registration after successful account creation
  // This also removes the password from Firestore for security
  Future<void> deletePendingRegistration(String email) async {
    try {
      await _firestore
          .collection('pending_registrations')
          .doc(email)
          .delete();
    } catch (e) {
      // Don't throw error if deletion fails, just log it
      debugPrint('Warning: Failed to delete pending registration: $e');
    }
  }

  // Generate a simple verification token
  String _generateVerificationToken() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        DateTime.now().hashCode.toString();
  }
}

