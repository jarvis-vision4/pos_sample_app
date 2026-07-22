class OrderListState {
  final bool isLoading;
  final String? error;

  const OrderListState({
    this.isLoading = false,
    this.error,
  });
  OrderListState  copyWith({
    bool? isLoading,
    String? error,
  }) {
    return OrderListState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}