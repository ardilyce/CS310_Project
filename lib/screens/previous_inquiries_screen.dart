import 'package:flutter/material.dart';
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
  List<Inquiry> _inquiries = mockInquiries;
  SortType _currentSortType = SortType.date;
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _sortInquiries(); // sort at the start
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _sortInquiries() {
    // some unnecessary local vars, but still ok
    List<Inquiry> list = _inquiries;
    SortType typeNow = _currentSortType;

    setState(() {
      if (typeNow == SortType.date) {
        list.sort((a, b) {
          return b.date.compareTo(a.date);
        });
      } else {
        list.sort((a, b) {
          return b.score.compareTo(a.score);
        });
      }
      _inquiries = list;
    });
  }

  int get _numberOfPages {
    int len = _inquiries.length;
    int pages = (len / inquiriesPerPage).ceil();
    return pages;
  }

  Widget _buildInquiryPage(int pageIndex) {
    int startIndex = pageIndex * inquiriesPerPage;
    int endIndex = startIndex + inquiriesPerPage;

    if (endIndex > _inquiries.length) {
      endIndex = _inquiries.length;
    }

    List<Inquiry> pageInquiries = _inquiries.sublist(startIndex, endIndex);

    List<Widget> cards = [];
    for (int i = 0; i < pageInquiries.length; i++) {
      Inquiry inquiry = pageInquiries[i];

      // ==== Delete Using Card ====
      cards.add(
        Dismissible(
          key: ValueKey(inquiry.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: AppUtility.riskRed,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: AppUtility.textWhite),
          ),
          onDismissed: (direction) {
            setState(() {
              _inquiries.remove(inquiry);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Inquiry deleted'),
              ),
            );
          },
          child: Card(
            // simple Card wrapper; InquiryCard still uses its own padding/margin
            margin: EdgeInsets.zero,
            elevation: 2,
            child: InquiryCard(
              inquiry: inquiry,
              onTap: () {
                _navigateToDetails(inquiry);
              },
            ),
          ),
        ),
      );
      // ===============================================================
    }

    return Column(
      children: cards,
    );
  }

  void _navigateToDetails(Inquiry inquiry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InquiryDetailsScreen(inquiry: inquiry);
        },
      ),
    );
  }

  void _handleSortChange(SortType? newSortType) {
    if (newSortType != null) {
      if (newSortType != _currentSortType) {
        _currentSortType = newSortType;
        _sortInquiries();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String sortText;
    if (_currentSortType == SortType.date) {
      sortText = 'by date';
    } else {
      sortText = 'by score';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Previous Inquiries',
          style: TextStyle(color: AppUtility.textWhite),
        ),
        backgroundColor: AppUtility.primaryBlue,
        iconTheme: IconThemeData(color: AppUtility.textWhite),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<SortType>(
                  onSelected: _handleSortChange,
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<SortType>>[
                      const PopupMenuItem(
                        value: SortType.date,
                        child: Text('Sort by Date'),
                      ),
                      const PopupMenuItem(
                        value: SortType.score,
                        child: Text('Sort by Score'),
                      ),
                    ];
                  },
                  child: Row(
                    children: [
                      Text(
                        sortText,
                        style: TextStyle(
                          color: AppUtility.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: AppUtility.textDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _numberOfPages,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildInquiryPage(index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_numberOfPages, (index) {
                bool isActive = _currentPageIndex == index;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppUtility.primaryBlue
                        : AppUtility.textGrey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
