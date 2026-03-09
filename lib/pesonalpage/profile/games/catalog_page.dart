import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();

  // 静态变量：共享的植物列表
  static List<Map<String, dynamic>> plants = [
    {
      'name': '橡树',
      'description': '粗壮的树干和宽阔的树冠，充满活力，象征力量与坚固。',
      'quantity': 0,
    },
    {
      'name': '樱花树',
      'description': '粉红色花瓣，象征美丽和春天，非常适合温暖、柔和的设计。',
      'quantity': 0,
    },
    {
      'name': '松树',
      'description': '常绿，像圣诞树一样高耸，简洁的三角形轮廓，非常易于卡通化。',
      'quantity': 0,
    },
    {
      'name': '椰子树',
      'description': '细长的树干，顶部有大大的叶片，常见于海滩场景，非常热带风情。',
      'quantity': 0,
    },
    {
      'name': '枫树',
      'description': '形状独特的枫叶，秋天时会变成红黄色，非常适合表现季节变化。',
      'quantity': 0,
    },
    {
      'name': '苹果树',
      'description': '树冠圆润，结满红苹果的树，象征丰收和简单的田园生活。',
      'quantity': 0,
    },
    {
      'name': '柳树',
      'description': '垂下的细长枝条，有柔美的线条，适合展现宁静、安逸的气氛。',
      'quantity': 0,
    },
    {
      'name': '桦树',
      'description': '白色树皮和细长的树干，简单优雅，非常容易卡通化表现。',
      'quantity': 0,
    },
    {
      'name': '香蕉树',
      'description': '宽大的叶片和一簇簇香蕉，热带风情明显，容易以简单的图形展示。',
      'quantity': 0,
    },
  ];

  // 静态方法：增加特定树的数量
  static void incrementTreeQuantity(String treeName) {
    for (var plant in plants) {
      if (plant['name'] == treeName) {
        plant['quantity'] += 1;
        print('${plant['name']} 数量增加到 ${plant['quantity']}');
        return;
      }
    }
    print('未找到树种: $treeName');
  }
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图鉴'),
        backgroundColor: Colors.green[600],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: CatalogPage.plants.length,
        itemBuilder: (context, index) {
          bool isUnlocked = CatalogPage.plants[index]['quantity'] > 0;
          String imagePath = 'assets/images/tree_${index + 1}.png';

          return GestureDetector(
            onTap: isUnlocked
                ? () {
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Column(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              imagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            CatalogPage.plants[index]['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        CatalogPage.plants[index]['description']!,
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('关闭'),
                        ),
                      ],
                    ),
              );
            }
                : null,
            child: Card(
              elevation: 5,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isUnlocked ? Colors.green : Colors.grey,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: isUnlocked
                          ? Image.asset(
                        imagePath,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.help_outline,
                        size: 70,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    isUnlocked
                        ? '${CatalogPage.plants[index]['name']} (${CatalogPage
                        .plants[index]['quantity']})'
                        : '？？？',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
