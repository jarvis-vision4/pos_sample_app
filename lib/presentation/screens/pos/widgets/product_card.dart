import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/data/models/product.dart';
import 'package:pos_sample_app/theme/app_theme.dart';
import 'package:pos_sample_app/utils/price_format.dart';
import '../../cart/cubit/cart_cubit.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.quantityInCart});

  final Product product;
  final int quantityInCart;

  @override
  Widget build(BuildContext context) {
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
                imageUrl: product.image,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) {
                  return const Center(child: Icon(Icons.image_not_supported, size: 40));
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
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        PriceFormat.format(product.price.toDouble()),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      if (quantityInCart > 0)
                        _QuantityControls(productId: product.id, quantity: quantityInCart)
                      else
                        InkWell(
                          onTap: () => context.read<CartCubit>().addToCart(product),
                          child: const Icon(Icons.add_circle, color: AppTheme.successColor, size: 28),
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
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({required this.productId, required this.quantity});

  final int productId;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.read<CartCubit>().decreaseQuantity(productId),
          child: const Icon(Icons.remove, size: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        InkWell(
          onTap: () => context.read<CartCubit>().increaseQuantity(productId),
          child: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }
}
