import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:c_o2e/flutter_flow/model/cart.dart'; // Ensure this reflects the correct path

class CartItem extends StatefulWidget {
  final CartItemData cartItemData;
  const CartItem({super.key, required this.cartItemData});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void increaseQuantity() {
    Provider.of<Cart>(context, listen: false)
        .updateItemQuantity(widget.cartItemData.shop, widget.cartItemData.quantity + 1);
  }

  void decreaseQuantity() {
    final newQuantity = widget.cartItemData.quantity - 1;
    if (newQuantity < 1) {
      Provider.of<Cart>(context, listen: false).removeItemFromCart(widget.cartItemData.shop);
    } else {
      Provider.of<Cart>(context, listen: false)
          .updateItemQuantity(widget.cartItemData.shop, newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: widget.cartItemData.shop.imagePath.isNotEmpty
            ? Image.network(
          widget.cartItemData.shop.imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.error),
        )
            : const Icon(Icons.image_not_supported),
        title: Text(widget.cartItemData.shop.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.cartItemData.shop.description}'),
            Text('${widget.cartItemData.shop.price.toStringAsFixed(0)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: decreaseQuantity,
            ),
            Text('${widget.cartItemData.quantity}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: increaseQuantity,
            ),
          ],
        ),
      ),
    );
  }
}
