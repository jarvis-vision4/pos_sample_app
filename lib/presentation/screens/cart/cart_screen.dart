import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_cubit.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_state.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/cart_items_list.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/checkout_section.dart';
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
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: state.selectedCustomer != null
                    ? Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.lightBlue,
                            child: Text(
                              state.selectedCustomer!.name.isNotEmpty
                                  ? state.selectedCustomer!.name[0]
                                        .toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.selectedCustomer!.name,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final customer = await Navigator.pushNamed(
                                context,
                                AppRoutes.customerSelection,
                              );
                              if (customer is Customer && context.mounted) {
                                context.read<CartCubit>().setCustomer(customer);
                              }
                            },
                            child: const Text('Change'),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(Icons.person_add, color: Colors.grey[400]),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'No customer selected',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final customer = await Navigator.pushNamed(
                                context,
                                AppRoutes.customerSelection,
                              );
                              if (customer is Customer && context.mounted) {
                                context.read<CartCubit>().setCustomer(customer);
                              }
                            },
                            child: const Text('Select Customer'),
                          ),
                        ],
                      ),
              ),

              Expanded(child: CartItemsList(state:state)),
              CheckoutSection(state: state)
            ],
          );
        },
      ),
    );
  }
}
