import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/pos_cubit.dart';
import 'cubit/pos_state.dart';
import 'widgets/cart_badge.dart';
import 'widgets/category_filter.dart';
import 'widgets/product_grid.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PosCubit>().loadCategories();
      context.read<PosCubit>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Screen'),
        actions: const [CartBadge()],
      ),
      body: BlocBuilder<PosCubit, PosState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error loading products', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<PosCubit>().loadProducts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              CategoryFilter(state: state),
              Expanded(child: ProductGrid(state: state)),
            ],
          );
        },
      ),
    );
  }
}
