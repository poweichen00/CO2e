import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../flutter_flow/like_button.dart';
import '../helper/helper_methods.dart';

class AdminPostWidget extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;
  final String? imageUrl;
  final VoidCallback? onDeletePressed;

  const AdminPostWidget({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.time,
    required this.likes,
    this.imageUrl,
    this.onDeletePressed,
  }) : super(key: key);

  @override
  _AdminPostWidgetState createState() => _AdminPostWidgetState();
}

class _AdminPostWidgetState extends State<AdminPostWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late bool isLiked;

  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // Toggle like
  void toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
    FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    try {
      if (isLiked) {
        await postRef.update({
          'Likes': FieldValue.arrayUnion([currentUser.email])
        });
      } else {
        await postRef.update({
          'Likes': FieldValue.arrayRemove([currentUser.email])
        });
      }
      print('Update successful');
    } catch (e) {
      print('Error updating likes: $e');
      // Revert the state if update fails
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  void deletePost(BuildContext context, String postId, String? imageUrl) async {
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

        // 刪除貼文相關的評論
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

        // 刪除貼文本身
        await FirebaseFirestore.instance
            .collection("User Posts")
            .doc(postId)
            .delete();

        print("貼文已刪除");
      } catch (error) {
        print("刪除貼文失敗: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            Center(
              child: Image.network(widget.imageUrl!),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        " . ",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deletePost(context, widget.postId, widget.imageUrl),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(commentData["CommentText"]),
                    subtitle: Text("${commentData["CommentedBy"]} • ${formatDate(commentData["CommentTime"])}"),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
