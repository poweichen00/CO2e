import 'package:flutter/material.dart';
import 'badge_detail_page.dart';
import 'badge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BadgePage extends StatefulWidget {
  @override
  _BadgePageState createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  List<AchievementBadge> badges = [
    AchievementBadge(
        id: '1',
        name: '減碳啟蒙者',
        description: '初次使用此應用程式，加入減碳環保的一份子，即可獲得減碳啟蒙者徽章!',
        imagePath: "lib/pages/badge/image/woman.png",
        voucher: 5,
        unlocked: false),
    AchievementBadge(
        id: '2',
        name: '綠能玩家',
        description: '累積點數超過1000點，即可獲得綠能玩家徽章!',
        imagePath: "lib/pages/badge/image/mother.png",
        voucher: 10,
        unlocked: false),
    AchievementBadge(
        id: '3',
        name: '綠能金牌',
        description: '累積點數超過5000點，即可獲得綠能金牌徽章!',
        imagePath: "lib/pages/badge/image/medal.png",
        voucher: 50,
        unlocked: false),
    AchievementBadge(
        id: '4',
        name: '冰山守護者',
        description: '累積點數超過10000點，即可獲得冰山守護者徽章，急速融化的冰川，由你守護!',
        imagePath: "lib/pages/badge/image/melting.png",
        voucher: 100,
        unlocked: false),
    AchievementBadge(
        id: '5',
        name: '環保小尖兵',
        description: '累積完成10次行動，即可獲得環保小尖兵徽章!',
        imagePath: "lib/pages/badge/image/cycle.png",
        voucher: 10,
        unlocked: false),
    AchievementBadge(
        id: '6',
        name: '環保戰士',
        description: '累積完成50次行動，即可獲得環保戰士徽章!',
        imagePath: "lib/pages/badge/image/nature.png",
        voucher: 50,
        unlocked: false),
    AchievementBadge(
        id: '7',
        name: '烏龜拯救者',
        description: '累積完成100次行動，即可獲得烏龜拯救者徽章，你就是烏龜們的大哥!',
        imagePath: "lib/pages/badge/image/turtle.png",
        voucher: 100,
        unlocked: false),
    // 更多徽章
  ];

  @override
  void initState() {
    super.initState();
    // 可能不需要在此處調用 _loadBadgeData，因為 StreamBuilder 會處理更新
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 131, 196, 149),
        elevation: 0,
      ),
      body: Container(
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '    徽章',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      offset: Offset(3.0, 3.0), // 陰影偏移量
                      blurRadius: 9.0, // 模糊半徑
                      color: Color.fromARGB(255, 83, 96, 98), // 陰影顏色
                    ),
                  ],
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(255, 236, 253, 255),
                        Color.fromARGB(255, 154, 239, 223)
                      ], // 漸變顏色
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '以下是您可以獲得的所有徽章。',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                color: const Color.fromARGB(207, 23, 78, 55),
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: userId != null
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('badge')
                          .snapshots()
                      : Stream.empty(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return Center(child: Text('No data available'));
                    }

                    final badgeData = snapshot.data!.docs;
                    final updatedBadges = List<AchievementBadge>.from(badges);

                    for (var doc in badgeData) {
                      final badgeId = doc.id;
                      final data = doc.data() as Map<String, dynamic>?;

                      // 確保 data 不為 null
                      if (data != null) {
                        final unlocked = data['unlocked'] ?? false;

                        for (var badge in updatedBadges) {
                          if (badge.id == badgeId) {
                            badge.unlocked = unlocked;
                          }
                        }
                      }
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 50,
                      ),
                      itemCount: updatedBadges.length,
                      itemBuilder: (context, index) {
                        return BadgeItem(badge: updatedBadges[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BadgeItem extends StatelessWidget {
  final AchievementBadge badge;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  BadgeItem({required this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BadgeDetailPage(badge: badge, userId: userId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(badge.imagePath),
              if (!badge.unlocked)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Icon(Icons.lock, color: Colors.white, size: 50),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
