import 'package:flutter/material.dart';
import 'utility_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/analysis_service.dart';
import 'analyze_screen.dart';

class ExtractedTextScreen extends StatefulWidget {
  const ExtractedTextScreen({super.key});

  @override
  State<ExtractedTextScreen> createState() => _ExtractedTextScreenState();
}

class _ExtractedTextScreenState extends State<ExtractedTextScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final extractedText =
          ModalRoute.of(context)!.settings.arguments as String;

      _textController.text = extractedText;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtility.background,
      appBar: AppBar(
        backgroundColor: AppUtility.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppUtility.textWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Image Upload",
          style: TextStyle(
            color: AppUtility.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// EDITABLE TEXT BOX
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 380,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppUtility.secondaryBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: TextStyle(
                      fontSize: 15,
                      color: AppUtility.textDark,
                    ),
                  ),
                ),

                /// EDIT ICON
                Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(Icons.edit, color: AppUtility.textGrey),
                ),
              ],
            ),

            const Spacer(),

            /// CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async { // MODIFIED THIS FUNCTION TO RUN THE RISK EVALUATION
                  final textToAnalyze = _textController.text.trim();

                  if (textToAnalyze.isEmpty) return;

                  // Analyses the text using the PhishGuard algorithm
                  final AnalysisResult result = AnalysisService.analyzeText(textToAnalyze);

                  final User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // Conversion for Firebase
                    List<Map<String, dynamic>> breakdownMap =
                    result.breakdown.map((item) => item.toMap()).toList();

                    // Upload to Firebase
                    await FirebaseFirestore.instance.collection('texts').add({
                      'text': result.originalText,
                      'score': result.score,
                      'riskLevel': result.riskLevel,
                      'breakdown': breakdownMap, // Now we save the specific risk details too!
                      'createdAt': Timestamp.now(),
                      'userId': user.uid,
                      'source': 'image_scan', // (Optional) Useful to know this came from OCR
                    });

                    // We pass the 'result' object as an argument so the next screens don't have to recalculate it.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalyzeScreen(result: result),
                      ),
                    );
                  } else {
                    // Handle case where user isn't logged in
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You must be logged in to analyze text.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtility.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Confirm Text",
                  style: TextStyle(
                    color: AppUtility.textWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
