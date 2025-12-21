import 'dart:ui' as ui; // Needed for the Painter
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utility_class.dart';
import '../services/analysis_service.dart';
import 'analyze_screen.dart';

// This is the new screen you asked for, based on your image.
class TextInputScreen extends StatefulWidget {
  const TextInputScreen({super.key});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _errorOverlay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _errorOverlay?.remove();
    super.dispose();
  }

  // This method will be called when the user taps the dashed box.
  void _handleTapToEnterText() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _showTopError(String message) {
    // Remove existing overlay if present
    if (_errorOverlay != null) {
      _errorOverlay!.remove();
      _errorOverlay = null;
    }

    final overlay = Overlay.of(context);
    _errorOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Just below status bar
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppUtility.riskRed,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: AppUtility.textWhite),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: AppUtility.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_errorOverlay!);

    // Remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _errorOverlay != null) {
        _errorOverlay!.remove();
        _errorOverlay = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the same logic as your example to make a square box
    double size = MediaQuery.of(context).size.width - 48;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUtility.primaryBlue, // Style from your example
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppUtility.textWhite),
          onPressed: () {
            // A standard back button action
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Input Text", // Title from your image
          style: TextStyle(
            color: AppUtility.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// KARE INPUT BOX
            GestureDetector(
              onTap: _handleTapToEnterText, // Call the tap handler
              child: Container(
                width: size,
                height: size, // KARE
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomPaint(
                  painter: _DashedBorderPainter(), // Re-using your painter
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        hintText: "Tap to enter text.",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppUtility.textDark,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(), // Pushes the button to the bottom
            /// BOTTOM BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async { // MODIFIED THIS FUNCTION TO RUN THE RISK EVALUATION
                  if (_textController.text.trim().isEmpty) {
                    _showTopError("Please enter some text first.");
                    return;
                  }
                  // Analyses the text using the PhishGuard algorithm
                  final AnalysisResult result = AnalysisService.analyzeText(_textController.text);

                  final User? user = _auth.currentUser;
                  if (user != null) {
                    // Conversion for Firebase
                    List<Map<String, dynamic>> breakdownMap = result.breakdown.map((item) => item.toMap()).toList();

                    // Upload to Firebase
                    await _firestore.collection('texts').add({
                      'text': result.originalText,
                      'score': result.score,
                      'riskLevel': result.riskLevel,
                      'breakdown': breakdownMap, // Saving the details for history!
                      'createdAt': Timestamp.now(),
                      'userId': user.uid,
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
                    _showTopError("You need to be logged in to save text.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtility.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Analyze From Text", // Text from your image
                  style: TextStyle(
                    color: AppUtility.textWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25), // Bottom spacing
          ],
        ),
      ),
    );
  }
}

///// PAINTER — dashed border
// This is the exact same painter class you provided.
class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 10;
    double dashSpace = 6;

    final paint = Paint()
      ..color = AppUtility.primaryBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16),
        ),
      );

    ui.PathMetrics pathMetrics = path.computeMetrics();
    for (ui.PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final extractPath = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
