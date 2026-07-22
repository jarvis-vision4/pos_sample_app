import '../../../../data/models/customer.dart';

class CustomerState {
  final List<Customer> customers;
  final Customer? selectedCustomer;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  const CustomerState({
    this.customers = const [],
    this.selectedCustomer,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  CustomerState copyWith({
    List<Customer>? customers,
    Customer? selectedCustomer,
    bool? isLoading,
    String? error,
    String? searchQuery
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery
    );
  }
}
