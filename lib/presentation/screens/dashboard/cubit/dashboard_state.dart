class DashboardState {
  final int counter;

  const DashboardState({this.counter = 0});

  DashboardState copyWith({int? counter}) {
    return DashboardState(counter: counter ?? this.counter);
  }
}
