class DashboardState {
  final double totalSales;
  final int totalCount;
  final bool isLoading;

  const DashboardState({
    this.totalSales = 0.0,
    this.totalCount=0,
    this.isLoading = true
  });

  DashboardState copyWith({
    double? totalSales,
    int? totalCount,
    bool? isLoading
  }) {
    return DashboardState(
        totalSales: totalSales ?? this.totalSales,
        totalCount: totalCount ?? this.totalCount,
        isLoading: isLoading ?? this.isLoading
    );
  }
}
