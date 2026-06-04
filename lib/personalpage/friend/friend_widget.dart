import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'friend_model.dart';
export 'friend_model.dart';

class FriendWidget extends StatefulWidget {
  const FriendWidget({super.key});

  @override
  State<FriendWidget> createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget> {
  late FriendModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _friendController = TextEditingController();
  List<Map<String, String>> _friendsList = [];
  List<Map<String, String>> _pendingRequestsList = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FriendModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _friendController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _addFriend() async {
    String friendEmail = _friendController.text.trim();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && friendEmail == currentUser.email) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You cannot add yourself as a friend.')),
      );
      return; // Stop the process
    }
    //check duplicate
    final currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();

    if (currentUserSnapshot.exists) {
      final currentUserData = currentUserSnapshot.data();
      final friendsList = List<String>.from(currentUserData?['friends'] ?? []);

      if (friendsList.contains(friendEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are already friends with $friendEmail')),
        );
        return; // 停止执行
      }
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: friendEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(querySnapshot.docs.first.id)
            .update({
          'pendingRequests': FieldValue.arrayUnion([currentUser.email])
        });

        setState(() {
          _friendController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend request sent to $friendEmail')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend not found')),
      );
    }
  }

  Future<void> _acceptFriend(String friendEmail) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'friends': FieldValue.arrayUnion([friendEmail])
      });

      final friendQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: friendEmail)
          .get();

      if (friendQuerySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(friendQuerySnapshot.docs.first.id)
            .update({
          'friends': FieldValue.arrayUnion([currentUser.email])
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'pendingRequests': FieldValue.arrayRemove([friendEmail])
        });

        setState(() {
          _friendsList.add({'email': friendEmail, 'photo_url': ''});
          _pendingRequestsList.removeWhere((request) => request['email'] == friendEmail);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend request accepted')),
        );
      }
    }
  }

  Future<void> _declineFriend(String friendEmail) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'pendingRequests': FieldValue.arrayRemove([friendEmail])
      });

      setState(() {
        _pendingRequestsList.removeWhere((request) => request['email'] == friendEmail);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request declined')),
      );
    }
  }

  Future<void> _deleteFriend(String friendEmail) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'friends': FieldValue.arrayRemove([friendEmail])
      });

      final friendQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: friendEmail)
          .get();

      if (friendQuerySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(friendQuerySnapshot.docs.first.id)
            .update({
          'friends': FieldValue.arrayRemove([currentUser.email])
        });

        setState(() {
          _friendsList.removeWhere((friend) => friend['email'] == friendEmail);
        });
      }
    }
  }

  Future<void> _loadFriendsAndRequests() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          final friendsEmails = List<String>.from(data['friends'] ?? []);
          final pendingRequestsEmails = List<String>.from(data['pendingRequests'] ?? []);

          _friendsList = await _fetchUserDetails(friendsEmails);
          _pendingRequestsList = await _fetchUserDetails(pendingRequestsEmails);

          setState(() {});
        }
      }
    }
  }

  Future<List<Map<String, String>>> _fetchUserDetails(List<String> emails) async {
    List<Map<String, String>> userDetails = [];

    for (String email in emails) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        userDetails.add({
          'email': userDoc['email'] ?? '',
          'photo_url': userDoc['photo_url'] ?? '',
        });
      }
    }

    return userDetails;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFriendsAndRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Friends',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'Urbanist',
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 50.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _friendController,
                decoration: InputDecoration(
                  labelText: 'Enter friend\'s email',
                  labelStyle: FlutterFlowTheme.of(context).bodyText1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addFriend,
                child: Text('Add Friend'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Urbanist',
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Pending Friend Requests',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    ..._pendingRequestsList.map((user) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['photo_url'] != ''
                              ? NetworkImage(user['photo_url']!) as ImageProvider
                              : const AssetImage('assets/default_avatar.png'),
                        ),
                        title: Text(user['email']!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () => _acceptFriend(user['email']!),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => _declineFriend(user['email']!),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 20.0),
                    Text(
                      'Friends',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    ..._friendsList.map((friend) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: friend['photo_url'] != ''
                              ? NetworkImage(friend['photo_url']!) as ImageProvider
                              : const AssetImage('assets/default_avatar.png'),
                        ),
                        title: Text(friend['email']!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFriend(friend['email']!),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
