import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../auth/firebase_auth/auth_util.dart';
import '../helper/helper_methods.dart';
import '/flutter_flow/comment.dart';
import '/flutter_flow/like_button.dart';
import 'comment_button.dart';
import 'delete_button.dart';
import '../../backend/backend.dart';
import 'flutter_flow_util.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  final String? imageUrl;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late bool isLiked;
  String? userPhotoUrl;
  bool isFriend = false;

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    _getUserPhotoAndCheckFriend();
  }

  void _getUserPhotoAndCheckFriend() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.user)
        .get();

    if (userDoc.docs.isNotEmpty) {
      if (mounted) {
        setState(() {
          userPhotoUrl = userDoc.docs.first.data()['photo_url'] ?? '';
        });
      }
    }

    // Check if the post author is a friend
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    List friends = currentUserDoc.data()?['friends'] ?? [];

    // 確保 friends 列表不為 null 且為 List
    if (friends.isNotEmpty && friends is List<String>) {
      if (mounted) {
        setState(() {
          isFriend = friends.contains(widget.user);
        });
      }
    } else {
      setState(() {
        isFriend = false; // 預設為 false
      });
    }
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

  //add a comment

  //add a comment
  void addComment(String commentText) {
    //write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  //show a dialog box for adding comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Add Comment"),
          content: TextField(
            controller: _commentTextController,
            decoration: InputDecoration(hintText: "Write a comment..."),
          ),
          actions: [
            //cancel button
            TextButton(
              onPressed: () {
                //pop box
                Navigator.pop(context);
                //clear controller
                _commentTextController.clear();
              },
              child: Text("Cancel"),
            ),
            //post button
            TextButton(
              onPressed: () {
                //add comment
                addComment(_commentTextController.text);
                //pop box
                Navigator.pop(context);
                //clear controller
                _commentTextController.clear();
              },
              child: Text("Post"),
            ),
          ]),
    );
  }

  void deletePost() {
    //show a dialog box asking for confirmation before deleting
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          //Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          //delete button
          TextButton(
            onPressed: () async {
              //delete comments from firestore
              if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
                Reference storageRef =
                    FirebaseStorage.instance.refFromURL(widget.imageUrl!);
                await storageRef.delete();
              }
              final commentDocs = await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }
              FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("post deleted"))
                  .catchError((error) => print("failed to delete post:$error"));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left:25,right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        //wallpost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //group of text(message + user email)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //message
                  Text(widget.message),

                  const SizedBox(height: 5),
                  //user
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style:TextStyle(color:Colors.grey[400]),
                      ),
                      Text(
                        " . ",
                        style:TextStyle(color:Colors.grey[400]),
                      ),
                      Text(
                        widget.time,
                        style:TextStyle(color:Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),

              //delete button
              if(widget.user == currentUser.email)
                DeleteButton(onTap:deletePost)
            ],
          ),
          const SizedBox(height: 20),
          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Like
            Column(
              children: [
                // Like button
                LikeButton(
                  isLiked: isLiked,
                  onTap: toggleLike,
                ),
                const SizedBox(height:5),
                Text(
                  widget.likes.length.toString(),
                  style:const TextStyle(color:Colors.grey),
                )
                // Like count (Optional: Add like count display here)
              ],
            ),
              const SizedBox(width:10),
              //comments
              Column(
                children: [
                  // Like button
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(height:5),
                  Text(
                    '0',
                    style:const TextStyle(color:Colors.grey),
                  )
                ],
              ),
          ],
          ),
          const SizedBox(height:20),
          //comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
            .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime",descending: true)
                .snapshots(),
              builder: (context,snapshot){
              //show loading circle if no data yet
                if(!snapshot.hasData){
                  return const Center(
                    child:CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,//for nested lists
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc){
                    //get the comment
                    final commentData=doc.data() as Map<String,dynamic>;
                    //return the comment
                    return Comment(
                        text:commentData["CommentText"],
                        user:commentData["CommentedBy"],
                        time:formatDate(commentData["CommentTime"]),
                    );
                  }).toList(),
                );
              },
          )
        ],
      ),
    );
  }
}*/
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
          // User avatar and info section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Display user avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: userPhotoUrl != null &&
                            userPhotoUrl!.isNotEmpty
                        ? NetworkImage(userPhotoUrl!)
                        : const NetworkImage(
                            'https://static1.squarespace.com/static/5b19478afcf7fdf58822588e/5bbf1fdf104c7bc7af13d373/5f8053af45255f310b97f900/1602309565844/CO2e+thumbnail.jpg?format=1500w'),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.user,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (isFriend) ...[
                            const SizedBox(width: 5),
                            Icon(Icons.person,
                                color: Colors.blue, size: 18), // Friend icon
                          ],
                        ],
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.message,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 15),
          if (widget.imageUrl != null)
            Center(
              child: Image.network(
                widget.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  int commentCount = snapshot.data!.docs.length;

                  return Row(
                    children: [
                      CommentButton(onTap: showCommentDialog),
                      const SizedBox(width: 10),
                      Text(
                        commentCount.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                },
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
            builder: (context, snapshot) {
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
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatDate(commentData["CommentTime"]),
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
