import 'package:flutter/material.dart';
import '../cubit/cart_state.dart';
import 'cart_card.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key, required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Add products from POS screen', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.items.length,
      itemBuilder: (context, index) => CartCard(item: state.items[index]),
    );
  }
}
