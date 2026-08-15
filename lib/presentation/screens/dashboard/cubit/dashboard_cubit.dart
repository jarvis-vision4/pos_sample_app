import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/services/database_service.dart';
import '../../../../locator/locator.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DatabaseService _databaseService = getIt.get<DatabaseService>();

  DashboardCubit() : super(const DashboardState());

  Future<void> loadDashboardData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait([
        _databaseService.getTotalSales(),
        _databaseService.getOrderCount(),
      ]);
      emit(state.copyWith(
        totalSales: results[0] as double,
        totalCount: results[1] as int,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
