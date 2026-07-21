import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/cart/widgets/cart_items_list.dart';
import 'package:pos_sample_app/routes/app_router.dart';
import 'package:pos_sample_app/routes/app_routes.dart';

import '../../../data/models/customer.dart';
import 'cubit/cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart & Checkout Screen"), actions: []),
      body: Column(
        children: [
          Row(
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
                onPressed: ()async{
                  final customer=await Navigator.pushNamed(context, AppRoutes.customerSelection);
                  print(customer);
                },
                child: const Text('Select Customer'),
              ),
            ],
          ),
          Expanded(child: CartItemsList()),
        ],
      ),
    );
  }
}
