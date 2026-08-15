import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/screens/cart/cubit/cart_cubit.dart';
import '../../../../presentation/screens/cart/cubit/cart_state.dart';
import '../../../../routes/app_routes.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) => prev.totalQuantity != curr.totalQuantity,
      builder: (context, state) {
        return IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart),
              if (state.totalQuantity > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '${state.totalQuantity}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
