import 'dart:ui' as ui; // Needed for the Painter
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // This method will be called when the user taps the dashed box.
  void _handleTapToEnterText() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    // Use the same logic as your example to make a square box
    double size = MediaQuery.of(context).size.width - 48;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4DBA), // Style from your example
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // A standard back button action
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Input Text", // Title from your image
          style: TextStyle(
            color: Colors.white,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
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
                onPressed: () {
                  // TODO: analyze from text logic
                  Navigator.pushReplacementNamed(context, '/analyze');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A4DBA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Analyze From Text", // Text from your image
                  style: TextStyle(
                    color: Colors.white,
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
      ..color = const Color(0xFF0A4DBA)
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
