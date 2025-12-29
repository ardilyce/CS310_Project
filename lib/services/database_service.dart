import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/analysis_service.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store user data
  Future<void> storeUserData({
    required String userId,
    required String email,
    required String name,
    required int age,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
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

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw 'Failed to load user data: $e';
    }
  }

  Future<void> updateUserData({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'name': name,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to update user data: $e';
    }
  }

  // Saving the Inquiries of the user to the database
  Future<void> saveInquiry({
    required String userId,
    required AnalysisResult result, // Now accepts the full result object
  }) async {
    try {
      // Standardize mapping for the breakdown items using the model's toMap()
      List<Map<String, dynamic>> breakdownMap =
      result.breakdown.map((item) => item.toMap()).toList();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('inquiries')
          .add({
        'message': result.originalText, // Matches the 'message' field in your history screen
        'score': result.score,
        'riskLevel': result.riskLevel,
        'breakdown': breakdownMap,
        'timestamp': FieldValue.serverTimestamp(), // Ensures correct sorting by date
      });
    } catch (e) {
      throw 'Failed to save inquiry: $e';
    }
  }

  // Fetching the inquirires of a user from the database
  Stream<QuerySnapshot> getUserInquiries(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('inquiries')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> clearUserHistory(String userId) async {
    try {
      var snapshots = await _firestore
          .collection('users')
          .doc(userId)
          .collection('inquiries')
          .get();

      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Failed to clear history: $e';
    }
  }

  // 2. Delete the user document from Firestore
  Future<void> deleteUserData(String userId) async {
    try {
      // Note: This only deletes the Firestore document, not the Auth account
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw 'Failed to delete user data: $e';
    }
  }

}
