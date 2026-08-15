class DashboardState {
  final double totalSales;
  final int totalCount;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.totalSales = 0.0,
    this.totalCount = 0,
    this.isLoading = true,
    this.error,
  });

  DashboardState copyWith({
    double? totalSales,
    int? totalCount,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      totalSales: totalSales ?? this.totalSales,
      totalCount: totalCount ?? this.totalCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
