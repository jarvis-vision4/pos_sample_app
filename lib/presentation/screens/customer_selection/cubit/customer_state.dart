import '../../../../data/models/customer.dart';

class CustomerState {
  final List<Customer> customers;
  final Customer? selectedCustomer;
  final bool isLoading;
  final String? error;

  const CustomerState({
    this.customers = const [],
    this.selectedCustomer,
    this.isLoading = false,
    this.error,
  });

  CustomerState copyWith({
    List<Customer>? customers,
    Customer? selectedCustomer,
    bool? isLoading,
    String? error,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
