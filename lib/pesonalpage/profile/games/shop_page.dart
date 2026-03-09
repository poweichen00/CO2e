import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

int totalPoints = 0;
int seedCount = 0;
int waterCount = 0;
int fertilizerCount = 0;
String? userEmail;

Future<void> updatePlantCounts(String? userEmail, int seedCount, int waterCount, int fertilizerCount) async {
  if (userEmail == null) return;

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('plant')
        .where('email', isEqualTo: userEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String docId = snapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection('plant')
          .doc(docId)
          .update({
        'seedCount': seedCount,
        'waterCount': waterCount,
        'fertilizerCount': fertilizerCount,
      });

      print('Plant counts updated successfully');
    } else {
      // 如果没有文档，创建新的文档
      await FirebaseFirestore.instance.collection('plant').add({
        'email': userEmail,
        'seedCount': seedCount,
        'waterCount': waterCount,
        'fertilizerCount': fertilizerCount,
      });

      print('New plant document created');
    }
  } catch (e) {
    print('Error updating plant counts: $e');
  }
}

Future<Map<String, int>> fetchPlantCounts(String? userEmail) async {
  if (userEmail == null) return {'seedCount': 0, 'waterCount': 0, 'fertilizerCount': 0};

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('plant')
        .where('email', isEqualTo: userEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot plantDoc = snapshot.docs.first;
      return {
        'seedCount': plantDoc['seedCount'] ?? 0,
        'waterCount': plantDoc['waterCount'] ?? 0,
        'fertilizerCount': plantDoc['fertilizerCount'] ?? 0,
      };
    } else {
      print('No plant data found for this user');
      return {'seedCount': 0, 'waterCount': 0, 'fertilizerCount': 0};
    }
  } catch (e) {
    print('Error fetching plant counts: $e');
    return {'seedCount': 0, 'waterCount': 0, 'fertilizerCount': 0};
  }
}

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchTotalPoints();
    _loadPlantCounts(); // 调用函数，不能只是定义它
  }

  // 获取当前用户的电子邮件
  void _getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  // 从 Firebase 获取用户的总点数
  void _fetchTotalPoints() async {
    if (userEmail == null) return;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = snapshot.docs.first;
        setState(() {
          totalPoints = userDoc['totalPoint'] ?? 0;
        });
      } else {
        print('No user found with this email');
      }
    } catch (e) {
      print('Error fetching points: $e');
    }
  }

  // 加载 plant 集合中的种子、水和肥料的数量
  Future<void> _loadPlantCounts() async {
    Map<String, int> plantCounts = await fetchPlantCounts(userEmail);

    setState(() {
      seedCount = plantCounts['seedCount']!;
      waterCount = plantCounts['waterCount']!;
      fertilizerCount = plantCounts['fertilizerCount']!;
    });
  }

  // 更新用户点数到 Firebase
  Future<void> _updatePoints(int newPoints) async {
    if (userEmail == null) return;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .update({'totalPoint': newPoints});

        print('User points updated successfully');
      } else {
        print('No user found with this email');
      }
    } catch (e) {
      print('Error updating points: $e');
    }
  }

  // 显示购买对话框并处理购买逻辑
  void _showPurchaseDialog(BuildContext context, String itemName, int itemCost, Function(int) onPurchase) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('购买 $itemName', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
              backgroundColor: Colors.green[100],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left, size: 30),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                      ),
                      Text('$quantity', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.arrow_right, size: 30),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  Text('每件 $itemCost 点数，总共 ${(itemCost * quantity)} 点数'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red[800]),
                  child: Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    int totalCost = itemCost * quantity;

                    if (totalPoints >= totalCost) {
                      onPurchase(quantity);
                      setState(() {
                        totalPoints -= totalCost;
                      });
                      await _updatePoints(totalPoints);
                      await updatePlantCounts(userEmail, seedCount, waterCount, fertilizerCount);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('点数不足！'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('确认购买'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('商店', style: TextStyle(fontFamily: 'PressStart2P')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text('点数: $totalPoints', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        backgroundColor: Colors.green[800],
      ),
      body: userEmail == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            _buildItemTile('种子', 'assets/images/seed.png', 50, seedCount, () {
              _showPurchaseDialog(context, '种子', 50, (quantity) {
                setState(() {
                  seedCount += quantity;
                });
              });
            }),
            _buildItemTile('水', 'assets/images/water.png', 50, waterCount, () {
              _showPurchaseDialog(context, '水', 50, (quantity) {
                setState(() {
                  waterCount += quantity;
                });
              });
            }),
            _buildItemTile('肥料', 'assets/images/shit.png', 100, fertilizerCount, () {
              _showPurchaseDialog(context, '肥料', 100, (quantity) {
                setState(() {
                  fertilizerCount += quantity;
                });
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(String itemName, String imagePath, int itemCost, int count, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: ListTile(
          leading: Image.asset(imagePath, width: 50, height: 50),
          title: Text(itemName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Text('剩余数量: $count'),
          trailing: ElevatedButton(
            onPressed: () => onPressed(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('购买'),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ShopPage(),
    theme: ThemeData(
      fontFamily: 'PressStart2P',
    ),
  ));
}
