import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/cubit/cart_cubit.dart';
import '../cart/cubit/cart_state.dart';
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
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PosCubit>().loadCategories();
      context.read<PosCubit>().loadProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POS Screen"),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              int count = state.totalQuantity;
              return CartBadge(count: count);
            },
          ),
        ],
      ),
      body: BlocBuilder<PosCubit, PosState>(
        builder: (context, state) {
          if (state.isLoadingCategories && state.isLoadingProducts) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                CategoryFilter(state: state),
                Expanded(child: ProductGrid(state: state)),
              ],
            );
          }
        },
      ),
    );
  }
}
