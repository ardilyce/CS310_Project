import 'package:flutter/material.dart';
import 'utility_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/analysis_service.dart';
import 'analyze_screen.dart';
import '../services/database_service.dart';
import '../providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtractedTextScreen extends StatefulWidget {
  final String extractedText;

  const ExtractedTextScreen({super.key, required this.extractedText});

  @override
  State<ExtractedTextScreen> createState() => _ExtractedTextScreenState();
}

class _ExtractedTextScreenState extends State<ExtractedTextScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.extractedText;
    
    // Listen to focus changes to scroll when keyboard opens
    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) {
        // Delay to ensure keyboard is shown
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtility.background,
      resizeToAvoidBottomInset: true,
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

      body: Column(
        children: [
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: 24,
              ),
              child: Column(
                children: [
                  /// EDITABLE TEXT BOX
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: 200,
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppUtility.secondaryBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _textController,
                          focusNode: _textFieldFocusNode,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
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
                ],
              ),
            ),
          ),

          // Fixed bottom button
          Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: AppUtility.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
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
                      // Get the KeepHistory preference
                      final prefs = await SharedPreferences.getInstance();
                      final bool shouldSave = prefs.getBool('keep_history') ?? true;

                      // Save to database only if that preference is set
                      if(shouldSave){// USE THE SERVICE: This saves to users/{uid}/inquiries
                        await DatabaseService().saveInquiry(
                          userId: user.uid,
                          result: result,
                        );
                      }
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
            ),
          ),
        ],
      ),
    );
  }
}
