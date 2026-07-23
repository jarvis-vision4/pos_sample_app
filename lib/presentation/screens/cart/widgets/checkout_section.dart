import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/data/models/customer.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_state.dart';
import '../cubit/cart_cubit.dart';

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({super.key, required this.state});
  final CartState state;

  @override
  Widget build(BuildContext context) {
    final selectedCustomer = state.selectedCustomer;
    return  Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Items:'),
              Text(
                '${state.totalQuantity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Ks ${state.totalAmount}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0984E3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:state.canCheckOut ? ()=>_showCheckoutDialog(context,selectedCustomer):null,
              child: state.isCheckingOut
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ) : const Text(
                'Checkout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 8,)
        ],
      ),
    );
  }
  void _showCheckoutDialog(BuildContext context,Customer? customer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Checkout'),
        content: const Text('Are you sure you want to place this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CartCubit>().checkout(customer!);
              Navigator.pop(ctx);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
