import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_sample_app/routes/app_routes.dart';
import 'cubit/order_list_cubit.dart';
import 'cubit/order_list_state.dart';
import 'widgets/order_card.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});
  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<OrderListCubit>().loadOrders();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          ),
        ),
      ),
      body: BlocBuilder<OrderListCubit,OrderListState>(builder: (context,state){
        final orders=state.orders;
        if(state.isLoading){
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context,index){
              final order=orders[index];
              return OrderCard(order: order);
            }
        );
      })
    );
  }
}
