import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/customer.dart';
import '../../../../routes/app_routes.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CustomerSection extends StatelessWidget {
  const CustomerSection({super.key, required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    final selectedCustomer = state.selectedCustomer;
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.lightBlue,
            child: selectedCustomer == null
                ? Icon(Icons.person_add, color: Colors.grey[400])
                : Text(
                    state.selectedCustomer!.name.isNotEmpty
                        ? state.selectedCustomer!.name[0].toUpperCase()
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
              selectedCustomer?.name ?? "Select Customer",
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
            child: Text(
              selectedCustomer == null ? 'Select Customer' : 'Change',
            ),
          ),
        ],
      ),
    );
  }
}
