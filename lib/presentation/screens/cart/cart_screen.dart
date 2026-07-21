
import 'package:flutter/material.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/cart_items_list.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cart & Checkout Screen"),
          actions: [

          ],
      ),
      body: Column(
        children: [
            Expanded(
                child: CartItemsList()
            )
        ],
      ),
    );
  }
}
