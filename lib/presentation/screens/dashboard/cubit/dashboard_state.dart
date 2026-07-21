class DashboardState {
  final bool isLoading;

  const DashboardState({
    this.isLoading = true,
  });

  DashboardState copyWith({bool? isLoading,}) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
