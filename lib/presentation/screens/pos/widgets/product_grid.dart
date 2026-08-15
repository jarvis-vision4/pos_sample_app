import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../cubit/pos_state.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.state});

  final PosState state;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 10,
      ),
      itemCount: state.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = state.filteredProducts[index];
        return BlocSelector<CartCubit, CartState, int>(
          selector: (cartState) {
            final cartItem = cartState.items.where((i) => i.product.id == product.id).firstOrNull;
            return cartItem?.quantity ?? 0;
          },
          builder: (context, quantityInCart) {
            return ProductCard(product: product, quantityInCart: quantityInCart);
          },
        );
      },
    );
  }
}
