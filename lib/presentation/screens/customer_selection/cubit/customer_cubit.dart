import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_sample_app/data/services/api_service.dart';
import 'package:pos_sample_app/presentation/screens/customer_selection/cubit/customer_state.dart';

import '../../../../data/models/customer.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final ApiService _apiService = GetIt.I.get<ApiService>();

  CustomerCubit() : super(const CustomerState());

  Future<void> loadCustomers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final customers = await _apiService.getAllCustomers();
      emit(state.copyWith(customers: customers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void searchCustomers(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(customers: state.customers, searchQuery: ''));
    } else {
      final filtered = state.customers
          .where(
            (c) =>
                c.name.toLowerCase().contains(query.toLowerCase()) || c.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(state.copyWith(customers: filtered, searchQuery: query));
    }
  }

  void selectCustomer(Customer customer) {
    emit(state.copyWith(selectedCustomer: customer));
  }
}
