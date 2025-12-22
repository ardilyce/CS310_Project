import 'package:flutter/material.dart';
import 'utility_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/analysis_service.dart';
import 'analyze_screen.dart';
import '../services/database_service.dart';
import '../providers/auth_provider.dart';

class ExtractedTextScreen extends StatefulWidget {
  final String extractedText;

  const ExtractedTextScreen({super.key, required this.extractedText});

  @override
  State<ExtractedTextScreen> createState() => _ExtractedTextScreenState();
}

class _ExtractedTextScreenState extends State<ExtractedTextScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.extractedText;
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
                    style: TextStyle(fontSize: 15, color: AppUtility.textDark),
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
                onPressed: () async {
                  final textToAnalyze = _textController.text.trim();
                  if (textToAnalyze.isEmpty) return;

                  final AnalysisResult result = AnalysisService.analyzeText(
                    textToAnalyze,
                  );
                  final User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // USE THE SERVICE: This saves to users/{uid}/inquiries
                    await DatabaseService().saveInquiry(
                      userId: user.uid,
                      result: result,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalyzeScreen(result: result),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You must be logged in to analyze text."),
                      ),
                    );
                  }
                },
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
