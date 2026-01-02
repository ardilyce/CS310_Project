import 'dart:ui' as ui; // Needed for the Painter
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utility_class.dart';
import '../services/analysis_service.dart';
import 'analyze_screen.dart';
import '../services/database_service.dart';
import '../providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final media = MediaQuery.of(context);

    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    // klavye açıksa > 0 olur
    final keyboardHeight = media.viewInsets.bottom;

    // AppBar + üst boşluk
    const appBarAndPadding = kToolbarHeight + 40;

    // kullanılabilir yükseklik
    final availableHeight = screenHeight - keyboardHeight - appBarAndPadding;

    // kare boyutu: genişliğe VE yüksekliğe göre güvenli
    final double size = ui.lerpDouble(
      screenWidth - 48,
      availableHeight * 0.65,
      keyboardHeight > 0 ? 1.0 : 0.0,
    )!;

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
                // Inside TextInputScreen's Analyze Button onPressed:
                onPressed: () async {
                  if (_textController.text.trim().isEmpty) {
                    _showTopError("Please enter some text first.");
                    return;
                  }

                  final AnalysisResult result = AnalysisService.analyzeText(
                    _textController.text,
                  );
                  final User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // Get the KeepHistory preference
                    final prefs = await SharedPreferences.getInstance();
                    final bool shouldSave = prefs.getBool('keep_history') ?? true;

                    // Save to database only if that preference is set
                    if(shouldSave){
                      // USE THE SERVICE: Standardized path and field names
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
