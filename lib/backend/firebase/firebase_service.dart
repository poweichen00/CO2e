import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/base_auth_user_provider.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<AuthUserInfo>> getMembers() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('users').get();
      List<AuthUserInfo> members = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return AuthUserInfo(
          uid: doc.id,
          email: doc['email'] ?? '',
          displayName: doc['display_name'] ?? '',
        );
      }).toList();

      return members;
    } catch (e) {
      print('Error fetching members: $e');
      return []; // 返回空列表或者可以处理错误情况
    }
  }

  Future<void> deleteUser(uid) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      // 刪除Firestore中的用戶文檔
      await _db.collection('users').doc(uid).delete();

      print('User $uid deleted successfully.');
    } catch (e) {
      print('Error deleting user $uid: $e');
    }
  }

}
