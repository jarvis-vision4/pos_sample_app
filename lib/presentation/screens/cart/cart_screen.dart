import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_cubit.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_state.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/cart_items_list.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/checkout_section.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/customer_section.dart';
import 'package:pos_sample_app/routes/app_routes.dart';
import 'package:pos_sample_app/theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart & Checkout'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            buildWhen: (prev, curr) => prev.items.isNotEmpty != curr.items.isNotEmpty,
            builder: (context, state) {
              if (state.items.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _showClearCartDialog(context),
                child: const Text('Clear Cart', style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listenWhen: (prev, curr) => curr.checkoutSuccess != prev.checkoutSuccess,
        listener: (context, state) {
          if (!state.checkoutSuccess) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          context.read<CartCubit>().resetCheckout();
          Navigator.pushReplacementNamed(context, AppRoutes.orders);
        },
        builder: (context, state) {
          return Column(
            children: [
              CustomerSection(state: state),
              Expanded(child: CartItemsList(state: state)),
              CheckoutSection(state: state),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear the cart?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
