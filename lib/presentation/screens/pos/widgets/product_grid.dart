import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/pos/widgets/product_card.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/pos_cubit.dart';
import '../cubit/pos_state.dart';

class ProductGrid extends StatelessWidget {
  final PosState state;

  const ProductGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error loading products',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.read<PosCubit>().loadProducts();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

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
        final cartState = context.watch<CartCubit>().state;
        final cartItem = cartState.items.where((item) => item.product.id == product.id)
            .firstOrNull;
        final quantityInCart = cartItem?.quantity ?? 0;
        return ProductCard(product:product,quantityInCart:quantityInCart);
      },
    );
  }
}
