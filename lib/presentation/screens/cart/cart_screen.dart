import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_cubit.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_state.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/cart_items_list.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/checkout_section.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/customer_section.dart';
import 'package:pos_sample_app/routes/app_routes.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart & Checkout Screen"), actions: []),
      body: BlocConsumer<CartCubit, CartState>(
        builder: (context, state) {
          return Column(
            children: [
              CustomerSection(state: state),
              Expanded(child: CartItemsList(state:state)),
              CheckoutSection(state: state)
            ],
          );
        },
        listenWhen:  (prev, curr) => curr.checkoutSuccess != prev.checkoutSuccess,
        listener: (context,state){
          final checkoutSuccess = state.checkoutSuccess;
          if (checkoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colors.cyanAccent,
              ),
            );
            context.read<CartCubit>().resetCheckout();
            Navigator.pushReplacementNamed(context, AppRoutes.orders);
          }
        },
      ),

    );
  }
}
