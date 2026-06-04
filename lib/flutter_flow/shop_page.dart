import 'package:flutter/material.dart';
import 'dart:async';
import 'package:c_o2e/flutter_flow/model/shop.dart';
import 'package:c_o2e/flutter_flow/shop_tile.dart';
import 'package:provider/provider.dart';
import 'package:c_o2e/flutter_flow/model/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce; // 用於防抖的計時器
  String searchQuery = '';
  bool isSearchTriggered = false; // 控制搜尋顯示的標誌

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        setState(() {
          searchQuery = query;
          isSearchTriggered = true; // 設置標誌為 true 以顯示搜尋結果
        });
      } else {
        setState(() {
          searchQuery = '';
          isSearchTriggered = false; // 查詢為空時顯示所有商店
        });
      }
    });
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      searchQuery = query;
      isSearchTriggered = true; // 設置標誌為 true 以顯示搜尋結果
    });
  }

  void addShopToCart(Shop shop) {
    Provider.of<Cart>(context, listen: false).addItemToCart(shop);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('成功加入！'),
        content: const Text('請檢查您的購物車'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 帶有 TextEditingController 的搜尋欄
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '搜尋',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSubmitted: _onSearchSubmitted,
                ),
              ),
              const Icon(Icons.search, color: Colors.grey),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Text(
            '拯救地球，從生活中的細節做起',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '熱門 🔥',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // 顯示搜尋結果或所有商店
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .where('name', isGreaterThanOrEqualTo: searchQuery)
                .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('發生錯誤'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('找不到商店'));
              }

              List<Shop> shops = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Shop(
                  name: data['name'] as String? ?? '',
                  price: data['price'] is int
                      ? data['price'] as int
                      : int.tryParse(data['price'].toString()) ?? 0,
                  imagePath: data['imagePath'] as String? ?? '',
                  description: data['description'] as String? ?? '',
                );
              }).toList();

              return ListView.builder(
                itemCount: shops.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Shop shop = shops[index];
                  return ShopTile(
                    shop: shop,
                    onTap: () => addShopToCart(shop),
                  );
                },
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 25, left: 25, right: 25),
          child: Divider(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
