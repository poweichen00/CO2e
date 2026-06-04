import 'package:flutter/material.dart';

import '../auth/base_auth_user_provider.dart';
import '../backend/firebase/firebase_service.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);
  static const String id = "members";
  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  late Future<List<AuthUserInfo>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture = FirebaseService().getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.person_outline),
            SizedBox(width: 10),
            Text('會員管理'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<AuthUserInfo>>(
        future: _membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('沒有會員數據'));
          } else {
            List<AuthUserInfo> members = snapshot.data!;
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                AuthUserInfo member = members[index];
                return ListTile(
                  title: Text(member.displayName ?? 'No Name'),
                  subtitle: Text(member.email ?? 'No Email'),
                  leading: member.photoUrl != null
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(member.photoUrl!),
                  )
                      : CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.person_remove_alt_1_outlined),
                    onPressed: () async {
                      // 確認刪除操作
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('刪除會員'),
                          content: Text('確定要刪除此會員嗎？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('取消'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('刪除'),
                            ),
                          ],
                        ),
                      );

                      if (confirm) {
                        await FirebaseService().deleteUser(member.uid);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('會員已成功刪除')),
                        );
                        // 刷新頁面
                        setState(() {
                          _membersFuture = FirebaseService().getMembers();
                        });
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
