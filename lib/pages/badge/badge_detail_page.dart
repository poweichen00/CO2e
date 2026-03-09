import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'badge_model.dart';

class BadgeDetailPage extends StatefulWidget {
  final AchievementBadge badge;
  final String userId;

  BadgeDetailPage({required this.badge, required this.userId});

  @override
  _BadgeDetailPageState createState() => _BadgeDetailPageState();
}

class _BadgeDetailPageState extends State<BadgeDetailPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _checkUnlockedStatus();
  }

  Future<void> _checkUnlockedStatus() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('badge')
        .doc(widget.badge.id)
        .get();

    if (snapshot.exists && snapshot.data()?['unlocked'] == true) {
      setState(() {
        isUnlocked = true;
      });
    }
  }

  Future<DateTime?> getUnlockedAt() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('badge')
        .doc(widget.badge.id)
        .get();

    if (snapshot.exists && snapshot.data()?['unlockedAt'] != null) {
      return (snapshot.data()!['unlockedAt'] as Timestamp).toDate();
    }
    return null;
  }

  Future<void> _shareBadge() async {
    try {
      if (!isUnlocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('该徽章尚未解锁，无法分享。')),
        );
        return;
      }

      // Capture the screenshot
      final Uint8List? image = await screenshotController.capture(
        pixelRatio: 2, // Reduce screenshot size
      );

      if (image == null) {
        return;
      }

      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();

      // Create a temporary file
      final File file = await File('${tempDir.path}/badge.png').create();

      // Write the image data to the file
      await file.writeAsBytes(image);

      // Share the image file using Share.shareXFiles
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '我刚刚解锁了一个徽章：${widget.badge.name}！赶快来看看吧！',
      );
    } catch (e) {
      print('Error sharing badge: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 131, 196, 149),
        elevation: 0,
      ),
      body: FutureBuilder<DateTime?>(
        future: getUnlockedAt(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('加载解锁时间时出错'));
          } else {
            final unlockedAt = snapshot.data;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 131, 196, 149),
                    Color.fromARGB(255, 44, 143, 49)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Wrap the badge details in Screenshot
                    Screenshot(
                      controller: screenshotController,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              widget.badge.name,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 9.0,
                                    color: Color.fromARGB(255, 193, 241, 211),
                                  ),
                                ],
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: <Color>[
                                      Colors.green,
                                      Color.fromARGB(255, 46, 86, 59)
                                    ],
                                  ).createShader(
                                      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 200, // Adjusted image size
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 193, 233, 203),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(widget.badge.imagePath),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (widget.badge.unlocked && unlockedAt != null)
                              Text(
                                '解锁时间: ${DateFormat('yyyy年M月d日 HH:mm').format(unlockedAt)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              widget.badge.description,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 2,
                      color: const Color.fromARGB(207, 23, 78, 55),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 24,
                          color: Color.fromARGB(255, 243, 224, 21),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '可获得${widget.badge.voucher}张兑换卷',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Show share button only if badge is unlocked
                    if (isUnlocked)
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: _shareBadge,
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
