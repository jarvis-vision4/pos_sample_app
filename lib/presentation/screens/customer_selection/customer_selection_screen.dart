import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/customer_cubit.dart';
import 'cubit/customer_state.dart';

class CustomerSelectionScreen extends StatefulWidget {
  const CustomerSelectionScreen({super.key});

  @override
  State<CustomerSelectionScreen> createState() => _CustomerSelectionScreenState();
}

class _CustomerSelectionScreenState extends State<CustomerSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerCubit>().loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Customer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Customer',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => context.read<CustomerCubit>().filterCustomers(value.trim()),
            ),
          ),
          Expanded(
            child: BlocBuilder<CustomerCubit, CustomerState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.filteredCustomers.isEmpty) {
                  return const Center(child: Text('No customers found'));
                }
                return ListView.builder(
                  itemCount: state.filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = state.filteredCustomers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF0984E3),
                        child: Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(customer.name),
                      subtitle: Text(customer.email),
                      onTap: () => Navigator.pop(context, customer),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
