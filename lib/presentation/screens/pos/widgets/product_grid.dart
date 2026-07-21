import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    // if (state.filteredProducts.isEmpty) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.inventory_2_outlined,
    //             size: 48, color: Colors.grey[400]),
    //         const SizedBox(height: 16),
    //         Text(
    //           'No products found',
    //           style: TextStyle(fontSize: 18, color: Colors.grey[600]),
    //         ),
    //       ],
    //     ),
    //   );
    // }

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
        final cartItem = state.cart
            .where((item) => item.product.id == product.id)
            .firstOrNull;
        final quantityInCart = cartItem?.quantity ?? 0;
        return Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: CachedNetworkImage(
                      imageUrl: product.image ?? "",
                      fit: BoxFit.contain,
                      errorWidget: (context, url,error) {
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 40),
                        );
                      },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // Formatters.formatPrice(product.price),
                            'Ks${product.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0984E3),
                            ),
                          ),
                          if (quantityInCart > 0)
                            Builder(
                              builder: (context) {
                                return Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        context.read<PosCubit>().decreaseQuantity(product.id!);
                                      },
                                      child: const Icon(Icons.remove, size: 18),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        '$quantityInCart',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        context.read<PosCubit>().increaseQuantity(product.id!);
                                      },
                                      child: const Icon(Icons.add, size: 18),
                                    ),
                                  ],
                                );
                              }
                            )
                          else
                            InkWell(
                              onTap: (){
                                print('Add to cart: ${product.id}');
                                context.read<PosCubit>().addToCart(product);
                              },
                              child: const Icon(
                                Icons.add_circle,
                                color: Color(0xFF00B894),
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
