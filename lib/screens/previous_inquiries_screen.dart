import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../services/database_service.dart';
import '../models/inquiry.dart';
import 'utility_class.dart';


enum SortType { date, score }


const EdgeInsets cardPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

class InquiryCard extends StatelessWidget {
  final Inquiry inquiry;
  final VoidCallback onTap;

  const InquiryCard({
    required this.inquiry,
    required this.onTap,
    super.key,
  });

  static const double _contentMaxHeight = 35.0;

  @override
  Widget build(BuildContext context) {
    // getting the color for the score
    Color scoreColor = AppUtility.getColorForScore(inquiry.score);

    String textToShow;
    if (inquiry.message == null) {
      textToShow = '<_Phishing message content...>';
    } else {
      textToShow = inquiry.message!;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        margin: cardPadding, // using the const from above (could just hardcode)
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppUtility.secondaryBlue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        inquiry.inquiryDateGen(),
                        style: TextStyle(
                          color: AppUtility.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '#Inquiry ID',
                        style: TextStyle(
                          color: AppUtility.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: _contentMaxHeight,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        // not very readable gradient but it works
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppUtility.textDark,
                            AppUtility.textDark,
                            Colors.transparent,
                          ],
                          stops: [
                            0.0,
                            0.7,
                            1.0,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Text(
                        textToShow,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppUtility.textDark,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: scoreColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppUtility.textWhite, width: 2),
              ),
              alignment: Alignment.center,
                child: Text(
                  inquiry.score.toString(),
                style: TextStyle(
                  color: AppUtility.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InquiryDetailsScreen extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryDetailsScreen({required this.inquiry, super.key});

  @override
  Widget build(BuildContext context) {
    // reusing same function as card
    Color scoreColor = AppUtility.getColorForScore(inquiry.score);

    String fullMessage;
    if (inquiry.message == null) {
      fullMessage = 'No content available.';
    } else {
      fullMessage = inquiry.message!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '# Inquiry ID',
          style: TextStyle(color: AppUtility.textWhite),
        ),
        backgroundColor: AppUtility.primaryBlue,
        iconTheme: IconThemeData(color: AppUtility.textWhite),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 80.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inquiry.inquiryDateGen(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppUtility.textDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '# Inquiry ID: ${inquiry.id}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppUtility.textGrey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: scoreColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          inquiry.score.toString(),
                          style: TextStyle(
                            color: AppUtility.textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 30),
                  Text(
                    'Phishing Message Content:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppUtility.textDark,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    fullMessage,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: AppUtility.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Re-analyzing inquiry...'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppUtility.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Analyze Again',
                  style: TextStyle(fontSize: 18, color: AppUtility.textWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const int inquiriesPerPage = 8;

class PreviousInquiriesScreen extends StatefulWidget {
  const PreviousInquiriesScreen({super.key});

  @override
  State<PreviousInquiriesScreen> createState() => _PreviousInquiriesScreenState();
}

class _PreviousInquiriesScreenState extends State<PreviousInquiriesScreen> {
  final DatabaseService _db = DatabaseService();
  SortType _currentSortType = SortType.date;

  @override
  Widget build(BuildContext context) {
    // Get the current user ID from your AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Inquiries', style: TextStyle(color: AppUtility.textWhite)),
        backgroundColor: AppUtility.primaryBlue,
        iconTheme: IconThemeData(color: AppUtility.textWhite),
      ),
      body: userId == null
          ? const Center(child: Text("Please log in to view history."))
          : StreamBuilder<QuerySnapshot>(
        stream: _db.getUserInquiries(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No history found."));
          }

          // Convert Firebase docs to Inquiry objects
          List<Inquiry> inquiries = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // Using your positional constructor: id, date, score, message
            return Inquiry(
              doc.id,                                          // id
              (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(), // date
              (data['score'] as num? ?? 0).toInt(),            // score
              data['message'] as String?,                      // message
            );
          }).toList();

          // Apply Sorting logic
          if (_currentSortType == SortType.score) {
            inquiries.sort((a, b) => b.score.compareTo(a.score));
          }

          return Column(
            children: [
              _buildSortDropdown(),
              Expanded(
                child: ListView.builder(
                  itemCount: inquiries.length,
                  itemBuilder: (context, index) {
                    final inquiry = inquiries[index];
                    return Dismissible(
                      key: ValueKey(inquiry.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: AppUtility.riskRed,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // Delete from Firebase
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('inquiries')
                            .doc(inquiry.id)
                            .delete();
                      },
                      child: InquiryCard(
                        inquiry: inquiry,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InquiryDetailsScreen(inquiry: inquiry),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Sort by: ", style: TextStyle(color: AppUtility.textGrey)),
          DropdownButton<SortType>(
            value: _currentSortType,
            onChanged: (SortType? newValue) {
              if (newValue != null) setState(() => _currentSortType = newValue);
            },
            items: const [
              DropdownMenuItem(value: SortType.date, child: Text("Date")),
              DropdownMenuItem(value: SortType.score, child: Text("Score")),
            ],
          ),
        ],
      ),
    );
  }
}
