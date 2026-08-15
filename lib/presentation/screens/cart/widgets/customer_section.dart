import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/data/models/customer.dart';
import 'package:pos_sample_app/routes/app_routes.dart';
import 'package:pos_sample_app/theme/app_theme.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CustomerSection extends StatelessWidget {
  const CustomerSection({super.key, required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    final customer = state.selectedCustomer;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.accentColor,
            child: customer == null
                ? Icon(Icons.person_add, color: Colors.grey[400])
                : Text(
                    customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              customer?.name ?? 'Select Customer',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, AppRoutes.customerSelection);
              if (result is Customer && context.mounted) {
                context.read<CartCubit>().setCustomer(result);
              }
            },
            child: Text(customer == null ? 'Select Customer' : 'Change'),
          ),
        ],
      ),
    );
  }
}
