import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
    required Map<String, dynamic> inquiryData,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('inquiries')
          .add({
        ...inquiryData,
        'timestamp': FieldValue.serverTimestamp(),
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
