import 'package:c_o2e/pages/badge/badge_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'badge_model.dart';

Future<String?> getCurrentUserId() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

Future<void> checkAndUnlockBadges(BuildContext context) async {
  String? userId = await getCurrentUserId();
  if (userId != null) {
    await checkAndUnlockSpecificBadgeConditions(context, userId);
  }
}

Future<void> unlockBadge(
    BuildContext context, String userId, String badgeId) async {
  CollectionReference badgeRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('badge');

  DocumentSnapshot badgeDoc = await badgeRef.doc(badgeId).get();
  Map<String, dynamic>? badgeData = badgeDoc.data() as Map<String, dynamic>?;

  bool hasUnlockedBefore = badgeData != null && badgeData['unlocked'] == true;

  if (!hasUnlockedBefore) {
    await badgeRef.doc(badgeId).set({
      'unlocked': true,
      'unlockedAt': FieldValue.serverTimestamp(),
    });

    int voucherCount = badgeVoucherMap[int.parse(badgeId)] ?? 0;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'totalVouchers': FieldValue.increment(voucherCount),
    });

    AchievementBadge? badge = findBadgeById(badgeId);
    if (badge != null) {
      await BadgeUnlocker()
          .showUnlockNotification(context, badge, voucherCount);
    }
  }
}

Future<void> checkAndUnlockSpecificBadgeConditions(
    BuildContext context, String userId) async {
  List<BadgeCondition> conditions = [
    BadgeCondition(
      id: '1',
      condition: () async => true, // 新增的 id=1，直接返回 true
    ),
    BadgeCondition(
      id: '2',
      condition: () async => checkTotalPoints(userId, 1000),
    ),
    BadgeCondition(
      id: '3',
      condition: () async => checkTotalPoints(userId, 5000),
    ),
    BadgeCondition(
      id: '4',
      condition: () async => checkTotalPoints(userId, 10000),
    ),
    BadgeCondition(
      id: '5',
      condition: () async => checkCompletedActions(userId, 10),
    ),
    BadgeCondition(
      id: '6',
      condition: () async => checkCompletedActions(userId, 50),
    ),
    BadgeCondition(
      id: '7',
      condition: () async => checkCompletedActions(userId, 100),
    ),
  ];

  for (var condition in conditions) {
    if (await condition.condition()) {
      await unlockBadge(context, userId, condition.id);
    }
  }
}

AchievementBadge findBadgeById(String badgeId) {
  return badges.firstWhere(
    (badge) => badge.id == badgeId,
    orElse: () => AchievementBadge(
      id: badgeId,
      name: 'Unknown Badge',
      description: 'This badge is not found.',
      imagePath: 'path/to/default/image.png',
      voucher: 0,
      unlocked: false,
    ),
  );
}

Future<int> getTotalPoints(String userId) async {
  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return userDoc.data()?['totalPoint'] ?? 0;
}

Future<bool> checkTotalPoints(String userId, int requiredPoints) async {
  final totalPoints = await getTotalPoints(userId);
  return totalPoints >= requiredPoints;
}

Future<bool> checkCompletedActions(String userId, int requiredActions) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? userEmail = user?.email;

  if (userEmail == null) return false;

  QuerySnapshot historySnapshot = await FirebaseFirestore.instance
      .collection('history')
      .where('UserEmail', isEqualTo: userEmail)
      .get();

  int completedActionsCount = historySnapshot.docs.length;

  return completedActionsCount >= requiredActions;
}

class BadgeCondition {
  final String id;
  final Future<bool> Function() condition;

  BadgeCondition({required this.id, required this.condition});
}

class BadgeUnlocker {
  Future<void> showUnlockNotification(
      BuildContext context, AchievementBadge badge, int voucherCount) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.orange,
                    size: 45,
                  ),
                  SizedBox(width: 10), // 調整圖標和文字之間的間距
                  Text(
                    '新徽章解鎖',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Image.asset(
                badge.imagePath,
                height: 100, // 設置徽章圖片的高度
                width: 100, // 設置徽章圖片的寬度
              ),
              const SizedBox(height: 10),
              Text(
                '${badge.name}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '獎勵 : $voucherCount 張兌換卷',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BadgeDetailPage(
                        badge: badge,
                        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '前往查看',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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

Map<int, int> badgeVoucherMap = {
  1: 5,
  2: 10,
  3: 50,
  4: 100,
  5: 10,
  6: 50,
  7: 100,
};
