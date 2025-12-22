import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "utility_class.dart";
import 'login_screen.dart';
import 'extracted_text_screen.dart';
import '../utils/ocr_utility.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  OverlayEntry? _errorOverlay;

  void _showTopError(String message) {
    if (_errorOverlay != null) {
      _errorOverlay!.remove();
      _errorOverlay = null;
    }

    final overlay = Overlay.of(context);
    _errorOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
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

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _errorOverlay != null) {
        _errorOverlay!.remove();
        _errorOverlay = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // DEVICE GENİŞLİĞİ (kare yapmak için lazım)
    double size = MediaQuery.of(context).size.width - 48;

    return Scaffold(
      backgroundColor: AppUtility.background,
      appBar: AppBar(
        backgroundColor: AppUtility.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppUtility.textWhite),
          onPressed: () {
            // Navigate back to home screen
            Navigator.pushReplacementNamed(context, '/home');
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// KARE UPLOAD BOX
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: size,
                height: size, // RECTANGLE DEĞİL → KARE
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomPaint(
                  painter: _DashedBorderPainter(),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: AppUtility.primaryBlue,
                              size: 45,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Tap to upload a photo",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppUtility.textDark,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Supported formats: JPG, PNG",
                              style: TextStyle(
                                color: AppUtility.textGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _selectedImage!,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),

            const Spacer(), // BUTONU EN ALTA İTER
            /// BOTTOM BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedImage == null) {
                    _showTopError("Please upload an image first.");
                    return;
                  }

                  final extractedText = await OcrUtility.extractText(
                    _selectedImage!,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExtractedTextScreen(extractedText: extractedText),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtility.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Analyze Image",
                  style: TextStyle(
                    color: AppUtility.textWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

///// PAINTER — dashed border
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
