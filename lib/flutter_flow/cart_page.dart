import 'package:c_o2e/flutter_flow/coupon_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:c_o2e/flutter_flow/model/cart.dart'; // 確保這個路徑正確
import 'cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<int> _fetchUserVouchers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final totalVouchers = userDoc.data()?['totalVouchers'] ?? 0;
    return totalVouchers as int;
  }

  Future<void> _updateUserVouchers(int newTotalVouchers) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'totalVouchers': newTotalVouchers});
  }

  Future<void> _savePurchasedCoupons(List<CartItemData> userCart) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userEmail = user.email; // 假設 email 可用
    final batch = FirebaseFirestore.instance.batch();
    final userCouponsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('purchasedCoupons');

    try {
      for (var item in userCart) {
        final couponRef = userCouponsRef.doc(item.shop.name);
        final existingCouponDoc = await couponRef.get();

        if (existingCouponDoc.exists) {
          // 如果優惠券已存在，更新數量
          final existingData = existingCouponDoc.data() as Map<String, dynamic>;
          final currentQuantity = existingData['quantity'] ?? 0;
          final newQuantity = currentQuantity + item.quantity;

          batch.update(couponRef, {
            'quantity': newQuantity,
            'datePurchased': FieldValue.serverTimestamp(),
          });
        } else {
          // 如果優惠券不存在，創建新條目
          batch.set(couponRef, {
            'name': item.shop.name,
            'description': item.shop.description,
            'quantity': item.quantity,
            'imagePath': item.shop.imagePath, // 儲存 imagePath
            'datePurchased': FieldValue.serverTimestamp(),
            'userEmail': userEmail,
          });
        }
      }
      await batch.commit();
      print('優惠券成功儲存！');
    } catch (e) {
      print('儲存優惠券時發生錯誤: $e');
    }
  }

  void _showCheckoutDialog(double totalAmount, int totalQuantity,
      List<CartItemData> userCart) async {
    final totalVouchers = await _fetchUserVouchers();
    final remainingAmount = (totalVouchers > totalAmount)
        ? (totalVouchers - totalAmount.toInt())
        : 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('兌換詳情'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('項目:'),
              for (var item in userCart)
                Text('${item.shop.name} : ${item.quantity}'),
              const SizedBox(height: 10),
              Text('總數量: $totalQuantity'),
              Text('兌換券數: \$${totalAmount.toStringAsFixed(2)}'),
              Text('持有兌換券: $totalVouchers'),
              Text('剩餘兌換券: \$${remainingAmount.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // 檢查優惠券是否足夠支付總金額
                if (totalVouchers >= totalAmount) {
                  // 執行成功結帳邏輯
                  final newTotalVouchers = totalVouchers - totalAmount.toInt();
                  await _updateUserVouchers(newTotalVouchers);

                  // 儲存購買的優惠券
                  await _savePurchasedCoupons(userCart);

                  // 顯示成功消息並導航到 CouponPage
                  Navigator.of(context).pop(); // 先關閉對話框
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('兌換成功'),
                        content: const Text('您的兌換成功。正在跳轉到優惠券頁面。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 關閉成功對話框
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CouponPage()),
                              );
                            },
                            child: const Text('確定',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // 顯示失敗消息
                  Navigator.of(context).pop(); // 先關閉對話框
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('購買失敗'),
                        content: const Text('您沒有足夠的優惠券來完成此購買。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 關閉失敗對話框
                            },
                            child: const Text('確定',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('確認', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關閉對話框
              },
              child: const Text('取消', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _handleCheckout(
      List<CartItemData> userCart, double totalAmount, int totalQuantity) {
    if (userCart.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('購物車為空'),
            content: const Text('您的購物車為空，無法進行結帳。'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 關閉對話框
                },
                child: const Text('確定', style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      );
    } else {
      _showCheckoutDialog(totalAmount, totalQuantity, userCart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        final List<CartItemData> userCart = cart.getUserCart();
        final int totalQuantity =
            userCart.fold(0, (sum, item) => sum + item.quantity);
        final double totalAmount = userCart.fold(0.0,
            (sum, item) => sum + (item.shop.price * item.quantity.toDouble()));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '我的購物車',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: userCart.length,
                  itemBuilder: (context, index) {
                    CartItemData individualCartItem = userCart[index];
                    return CartItem(cartItemData: individualCartItem);
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                      _handleCheckout(userCart, totalAmount, totalQuantity),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 89, 145, 90)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 20)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 15)),
                  ),
                  child: const Text('兌換', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
