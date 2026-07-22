
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/customer_selection/cubit/customer_cubit.dart';

import 'cubit/customer_state.dart';

class CustomerSelectionScreen extends StatefulWidget {
  const CustomerSelectionScreen({super.key});

  @override
  State<CustomerSelectionScreen> createState() => _CustomerSelectionScreenState();
}

class _CustomerSelectionScreenState extends State<CustomerSelectionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerCubit>().loadCustomers();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Customer"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 4),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Customer',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                print(value);
                context.read<CustomerCubit>().searchCustomers(value.trim());
              },
            ),
          ),
          Expanded(
              child: BlocBuilder<CustomerCubit,CustomerState>(builder: (context,state){
                if(state.isLoading){
                  return const Center(child: CircularProgressIndicator(),);
                }
                return ListView.builder(
                  itemCount: state.customers.length,
                  itemBuilder: (context,index){
                    final customer=state.customers[index];
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: Text(customer.email),
                      onTap: (){
                        context.read<CustomerCubit>().selectCustomer(customer);
                        Navigator.pop(context, customer);
                      },
                    );
                  },
                );
              })
          )
        ],
      ),
    );
  }
}
