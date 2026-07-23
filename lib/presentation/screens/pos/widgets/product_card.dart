import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/data/models/product.dart';

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
                    product.title,
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
                        'Ks${product.price.toStringAsFixed(2)}',
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
                                      context.read<CartCubit>().decreaseQuantity(product.id);
                                    },
                                    child: const Icon(Icons.remove, size: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Text(
                                      '$quantityInCart',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      context.read<CartCubit>().increaseQuantity(product.id);
                                    },
                                    child: const Icon(Icons.add, size: 20),
                                  ),
                                ],
                              );
                            }
                        )
                      else
                        InkWell(
                          onTap: (){
                            print('Add to cart: ${product.id}');
                            context.read<CartCubit>().addToCart(product);
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
  }
}
