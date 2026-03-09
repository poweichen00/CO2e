import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/coupon.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  Future<List<Coupon>> _fetchUserCoupons() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final userCouponsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchasedCoupons');

      final snapshot = await userCouponsRef.get();
      return snapshot.docs.map((doc) => Coupon.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching coupons: $e');
      return [];
    }
  }

  Future<void> _useCoupon(Coupon coupon) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final couponRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('purchasedCoupons')
        .doc(coupon.id);

    if (coupon.quantity > 1) {
      await couponRef.update({'quantity': coupon.quantity - 1});
    } else {
      await couponRef.delete();
    }

    // 異步操作完成後再更新狀態
    if (mounted) {
      setState(() {});
    }
  }

  void _confirmUseCoupon(Coupon coupon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('使用優惠券'),
          content: const Text('本券只限兌換一次。'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                await _useCoupon(coupon);
                Navigator.of(context).pop();
              },
              child: const Text('使用'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的優惠券'),
        backgroundColor: const Color.fromARGB(255, 89, 145, 90),
      ),
      body: FutureBuilder<List<Coupon>>(
        future: _fetchUserCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('錯誤: ${snapshot.error}'));
          } else {
            final coupons = snapshot.data ?? [];
            return ListView.builder(
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                final imagePath = coupon.imagePath;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 40, // 外圓形大小
                    backgroundColor: Colors.grey[200], // 背景顏色設為灰色
                    child: ClipOval(
                      child: (imagePath != null && imagePath.isNotEmpty)
                          ? Image.network(
                              imagePath,
                              width: 50, // 圖片寬度較小
                              height: 50, // 圖片高度較小
                              fit: BoxFit.contain, // 確保圖片不被裁剪
                            )
                          : const Icon(Icons.image_not_supported,
                              color: Colors.white),
                    ),
                  ),
                  title: Text(coupon.name),
                  subtitle: Text(coupon.description),
                  trailing: Text('數量: ${coupon.quantity}'),
                  onTap: () => _confirmUseCoupon(coupon),
                );
              },
            );
          }
        },
      ),
    );
  }
}