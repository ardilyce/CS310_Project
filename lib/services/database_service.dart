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

}
