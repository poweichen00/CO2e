import 'package:flutter/material.dart';
import '../option.dart';
import '../diet/diet_option_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

class DietOptionDetail extends StatefulWidget {
  final int optionId;
  final DietOptionList dietOptionList;

  DietOptionDetail({
    required this.optionId,
    required this.dietOptionList,
  });
  @override
  _DietOptionDetailState createState() => _DietOptionDetailState();
}

class _DietOptionDetailState extends State<DietOptionDetail> {
  Future<void> _saveToFirebase(Option option) async {
    try {
      // 先檢查是否已經存在相同的 UserEmail 和 name
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('options')
          .where('UserEmail', isEqualTo: currentUser?.email)
          .where('name', isEqualTo: option.name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 如果找到相同的記錄，則顯示錯誤訊息
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('錯誤'),
            content: const Text('您已經參與過此行動，不能重複參與!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // 关闭对话框
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // 如果沒有找到相同的記錄，則可以繼續添加到 Firebase
        await FirebaseFirestore.instance.collection('options').add({
          'UserEmail': currentUser?.email,
          'TimeStamp': Timestamp.now(),
          'name': option.name,
          'point': option.point,
          'description': option.description ?? 'No description',
          'imagePath': option.imagePath,
        });

        // 添加成功後顯示提示信息並返回上一頁
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('參與行動',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('行動已加入個人清單!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭对话框
                  Navigator.of(context).pop(); // 返回上一页
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error adding option to Firebase: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('錯誤'),
          content: const Text('添加行動時發生錯誤，請重試。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Option? option = widget.dietOptionList.getOptionById(widget.optionId);

    if (option == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Option Not Found'),
          backgroundColor: Colors.redAccent,
        ),
        body: const Center(
          child: Text(
            'The option you are looking for does not exist.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   option.name,
        //   style: const TextStyle(fontSize: 24),
        // ),
        backgroundColor: const Color.fromARGB(255, 117, 238, 121),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 117, 238, 121),
              Colors.grey.shade400
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 13, 96, 31)
                        .withOpacity(0.5), // 陰影顏色
                    spreadRadius: 2, // 陰影擴散半徑
                    blurRadius: 5, // 陰影模糊半徑
                    offset: const Offset(0, 4), // 陰影偏移
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  option.imagePath,
                  height: 150,
                  width: 150, // 設置圖片寬度
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              option.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black45,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.stars,
                    color: Color.fromARGB(255, 7, 73, 29), size: 24),
                const SizedBox(width: 8),
                Text(
                  '${option.point} /點',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 7, 73, 29),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // const Row(
            //   children: [
            //     Text(
            //       '描述:',
            //       style: TextStyle(
            //         fontSize: 22,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black45,
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              height: 2, // 底線的高度
              color: const Color.fromARGB(115, 162, 161, 161), // 底線的顏色
              width: double.infinity, // 底線的寬度
            ),

            const SizedBox(height: 8),
            Text(
              option.description ?? 'No description available',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black45,
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveToFirebase(option);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(177, 112, 183, 121),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  side: const BorderSide(
                    color: Color.fromARGB(128, 211, 243, 216),
                    width: 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_people, size: 24),
                    SizedBox(width: 8),
                    Text(
                      '參與此行動',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
