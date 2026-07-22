import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_cubit.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_state.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/cart_items_list.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/checkout_section.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/customer_section.dart';
import 'package:pos_sample_app/routes/app_routes.dart';

import '../../../data/models/customer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart & Checkout Screen"), actions: []),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final selectedCustomer = state.selectedCustomer;
          return Column(
            children: [
              CustomerSection(state: state),
              Expanded(child: CartItemsList(state:state)),
              CheckoutSection(state: state)
            ],
          );
        },
      ),
    );
  }
}
