import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({super.key});

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  String? userID;
  String? userEmail;
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchTotalPoints(); // 讀取並顯示累積點數
  }

  void _getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userID = user?.uid;
      userEmail = user?.email;
    });
  }

  Future<void> _fetchTotalPoints() async {
    if (userID != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userID);
      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // 從文檔中讀取 totalPoint 字段
        final totalPointValue = userDocSnapshot['totalPoint'] as int? ?? 0;
        setState(() {
          totalPoints = totalPointValue;
        });
      } else {
        print('文檔不存在');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('文檔不存在')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userEmail == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('options')
                  .where('UserEmail', isEqualTo: userEmail)
                  .orderBy('TimeStamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching actions'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('尚未選擇任務，快去挑選吧!'));
                }

                final actions = snapshot.data!.docs;

                return Stack(
                  children: [
                    GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: actions.length,
                      itemBuilder: (context, index) {
                        final action = actions[index];
                        final name = action['name'];
                        final point = action['point'];
                        final description = action['description'];
                        final imagePath = action['imagePath'];
                        final timestamp = action['TimeStamp'] as Timestamp;
                        final formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                            .format(timestamp.toDate());

                        return GestureDetector(
                          onTap: () {
                            // Handle card tap
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade200,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade700,
                                  blurRadius: 4.0,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '+$point',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () => _completeAction(action),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.blueGrey),
                                      onPressed: () => _deleteAction(action.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 4.0,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars,
                                color: Color.fromARGB(255, 7, 73, 29),
                                size: 24),
                            const SizedBox(width: 8.0),
                            Text(
                              '累積點數: $totalPoints',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 7, 73, 29),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Future<void> _completeAction(DocumentSnapshot action) async {
    final point = action['point'] ?? 0;
    final docId = action.id;
    final name = action['name'];
    final description = action['description'];
    final imagePath = action['imagePath'];
    final timestamp = action['TimeStamp'] as Timestamp;

    // 確認是否完成任務
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('完成任務'),
        content: const Text('確定要完成此任務嗎？'),
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('確認'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userID);
      final userDocSnapshot = await userDocRef.get();

      // 確認文件是否存在，如果不存在則初始化文件
      if (!userDocSnapshot.exists) {
        await userDocRef.set({'totalPoint': 0});
      }

      // 获取当前 totalPoint 并进行更新
      final currentTotalPoints = (userDocSnapshot['totalPoint'] as int?) ?? 0;
      final int incrementedPoints = point is int
          ? point
          : point is String
              ? int.tryParse(point) ?? 0
              : point is double
                  ? point.toInt()
                  : 0;

      await userDocRef.update({
        'totalPoint': currentTotalPoints + incrementedPoints,
      });

      setState(() {
        totalPoints += incrementedPoints;
      });

      // 将任务详情保存到 history collection
      await FirebaseFirestore.instance.collection('history').add({
        'UserEmail': userEmail,
        'name': name,
        'description': description,
        'point': incrementedPoints,
        'imagePath': imagePath,
        'TimeStamp': timestamp,
        'completedAt': Timestamp.now(), // 添加任务完成时间
      });

      // 刪除該任務
      await FirebaseFirestore.instance
          .collection('options')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('任務已完成')),
      );
    }
  }

  Future<void> _deleteAction(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除任務'),
        content: const Text('確定要刪除此任務嗎？'),
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('確認'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('options')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('任務已刪除')),
      );
    }
  }
}
