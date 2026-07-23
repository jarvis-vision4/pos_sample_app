import '../../../../data/models/order.dart';

class OrderListState {
  final bool isLoading;
  final String? error;
  final List<Order> orders;
  const OrderListState({
    this.isLoading = false,
    this.error,
    this.orders= const []
  });
  OrderListState  copyWith({
    bool? isLoading,
    String? error,
    List<Order>? orders,
  }) {
    return OrderListState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      orders: orders ?? this.orders
    );
  }
}