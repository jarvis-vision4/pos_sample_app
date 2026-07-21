import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/data/models/product.dart';
import 'package:pos_sample_app/presentation/screens/pos/cubit/pos_cubit.dart';
import 'package:pos_sample_app/presentation/screens/pos/cubit/pos_state.dart';
import 'package:pos_sample_app/presentation/screens/pos/widgets/category_filter.dart';
import 'package:pos_sample_app/presentation/screens/pos/widgets/product_grid.dart';
import 'package:pos_sample_app/routes/app_routes.dart';

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
          IconButton(onPressed: () {
            Navigator.pushNamed(context,AppRoutes.cart);
          }, icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: BlocBuilder<PosCubit,PosState>(builder: (context, state) {
        if (state.isLoadingCategories && state.isLoadingProducts) {
          return const Center(child: CircularProgressIndicator());
        }
        else{
          return Column(
            children: [
              CategoryFilter(state: state),
              Expanded(child: ProductGrid(state: state)),
            ],
          );
        }
      })
    );
  }
}
