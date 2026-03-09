import 'dart:io';

import 'package:c_o2e/admin_home/admin_post_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../flutter_flow/flutter_flow_animations.dart';
import '../helper/helper_methods.dart';
import 'dashboard_screen.dart';

class PostsScreen extends StatefulWidget {
  static const String id = "posts";

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  final textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.post_add),
            SizedBox(width: 10),
            Text('貼文管理'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User Posts')
            .orderBy('TimeStamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available'));
          } else {
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                final postData = doc.data() as Map<String, dynamic>;

                Timestamp timestamp = postData['TimeStamp'] as Timestamp;

                return Column(
                  children: [
                    AdminPostWidget(
                      message: postData['Message'] ?? '',
                      user: postData['UserEmail'] ?? '',
                      postId: doc.id,
                      likes: List<String>.from(postData['Likes'] ?? []),
                      time: postData['TimeStamp'] != null
                          ? formatDate(timestamp)
                          : '',
                      imageUrl: postData['ImageUrl'] ?? '',
                      onDeletePressed: () =>
                          deletePostAdmin(context, doc.id, postData['ImageUrl']),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostDialog(context),
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('新增管理員公告'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 20),
                  _selectedImage != null
                      ? Stack(
                    children: [
                      Image.file(_selectedImage!, height: 150),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImage = null;
                              imageUrl = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              hintText: 'Write something on the wall...',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                            if (file == null) return;

                            setState(() {
                              _selectedImage = File(file.path);
                            });

                            try {
                              String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                              Reference referenceImageToUpload = FirebaseStorage.instance
                                  .ref()
                                  .child('images')
                                  .child(uniqueFileName);

                              await referenceImageToUpload.putFile(_selectedImage!);
                              imageUrl = await referenceImageToUpload.getDownloadURL();
                            } catch (error) {
                              print("上傳圖片失敗: $error");
                            }
                          },
                          icon: const Icon(Icons.image),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                      imageUrl = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String message = messageController.text;

                    if (message.isNotEmpty || imageUrl != null) {
                      try {
                        await FirebaseFirestore.instance.collection('User Posts').add({
                          'Message': message,
                          'ImageUrl': imageUrl,
                          'UserEmail': currentUser.email,
                          'TimeStamp': Timestamp.now(),
                          'Likes': [],
                        });
                        Navigator.of(context).pop();
                      } catch (error) {
                        print("新增貼文失敗: $error");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('新增貼文失敗')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('請輸入消息或上傳圖片')),
                      );
                    }

                    setState(() {
                      _selectedImage = null;
                      imageUrl = null;
                    });
                  },
                  child: const Text('新增'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deletePostAdmin(BuildContext context, String postId, String? imageUrl) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("刪除貼文"),
        content: const Text("你確定要刪除這篇貼文嗎？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("刪除"),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        if (imageUrl != null && imageUrl.isNotEmpty) {
          Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
          await storageRef.delete();
        }

        final commentDocs = await FirebaseFirestore.instance
            .collection("User Posts")
            .doc(postId)
            .collection("Comments")
            .get();

        for (var doc in commentDocs.docs) {
          await FirebaseFirestore.instance
              .collection("User Posts")
              .doc(postId)
              .collection("Comments")
              .doc(doc.id)
              .delete();
        }

        await FirebaseFirestore.instance
            .collection("User Posts")
            .doc(postId)
            .delete();

        print("貼文已刪除");
      } catch (error) {
        print("刪除貼文失敗: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('刪除貼文失敗: $error')),
        );
      }
    }
  }
}
