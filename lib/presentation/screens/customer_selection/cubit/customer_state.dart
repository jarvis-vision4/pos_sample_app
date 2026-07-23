import '../../../../data/models/customer.dart';

class CustomerState {
  final List<Customer> customers;
  final List<Customer> filteredCustomers;
  final bool isLoading;
  final String? error;
  final String? searchQuery;

  const CustomerState({
    this.customers = const [],
    this.filteredCustomers = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  CustomerState copyWith({
    List<Customer>? customers,
    List<Customer>? filteredCustomers,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      filteredCustomers: filteredCustomers ?? this.filteredCustomers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
