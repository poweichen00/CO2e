import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('歷史紀錄'),
      ),
      body: userEmail == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('history')
                  .where('UserEmail', isEqualTo: userEmail)
                  .orderBy('completedAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching history'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('尚未有歷史紀錄!'));
                }

                final historyDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: historyDocs.length,
                  itemBuilder: (context, index) {
                    final history = historyDocs[index];
                    final historyData = history.data() as Map<String, dynamic>?;

                    if (historyData == null) {
                      return const SizedBox.shrink();
                    }

                    final name = historyData['name'];
                    final description = historyData['description'];
                    final point = historyData['point'];
                    final imagePath = historyData['imagePath'];

                    // Check if TimeStamp exists before using it
                    final timestamp = historyData.containsKey('TimeStamp')
                        ? historyData['TimeStamp'] as Timestamp?
                        : null;
                    final completedAt = historyData['completedAt'] as Timestamp;

                    final formattedDate = timestamp != null
                        ? DateFormat('yyyy-MM-dd – kk:mm')
                            .format(timestamp.toDate())
                        : 'N/A';
                    final completedDate = DateFormat('yyyy-MM-dd – kk:mm')
                        .format(completedAt.toDate());

                    return Card(
                      child: ListTile(
                        leading: imagePath != null
                            ? Image.asset(imagePath,
                                fit: BoxFit.contain, width: 50.0)
                            : null,
                        title: Text(name, style: const TextStyle(fontSize: 18)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(description),
                            const SizedBox(height: 4),
                            Text('Points: +$point'),
                            const SizedBox(height: 4),
                            Text('新增日期: $formattedDate'),
                            Text('完成日期: $completedDate'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
