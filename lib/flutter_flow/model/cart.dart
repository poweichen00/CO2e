import 'package:flutter/material.dart';
import 'package:c_o2e/flutter_flow/model/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart with ChangeNotifier {
  final List<CartItemData> _userCart = [];

  List<CartItemData> getUserCart() => _userCart;

  void addItemToCart(Shop shop) {
    final index = _userCart.indexWhere((item) => item.shop.name == shop.name);
    if (index == -1) {
      _userCart.add(CartItemData(shop: shop, quantity: 1));
    } else {
      _userCart[index].quantity++;
    }
    notifyListeners();
    _saveCartToFirebase();
  }

  void removeItemFromCart(Shop shop) {
    _userCart.removeWhere((item) => item.shop.name == shop.name);
    notifyListeners();
    _saveCartToFirebase();
  }

  void updateItemQuantity(Shop shop, int quantity) {
    final index = _userCart.indexWhere((item) => item.shop.name == shop.name);
    if (index != -1) {
      if (quantity <= 0) {
        removeItemFromCart(shop);
      } else {
        _userCart[index].quantity = quantity;
        notifyListeners();
        _saveCartToFirebase();
      }
    }
  }

  Future<void> _saveCartToFirebase() async {
    try {
      // Fetch the actual user ID dynamically, for example:
      // final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
      final userId = 'userId'; // Replace with actual user ID

      final cartData = _userCart.map((item) => {
        'name': item.shop.name,
        'price': item.shop.price,
        'quantity': item.quantity,
        'imagePath': item.shop.imagePath,
      }).toList();

      await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .set({'items': cartData});
    } catch (e) {
      // Handle error
      print('Failed to save cart: $e');
    }
  }
}

class CartItemData {
  final Shop shop;
  int quantity;

  CartItemData({required this.shop, this.quantity = 1});
}
