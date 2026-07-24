import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../data/services/database_service.dart';
import '../../../../locator/locator.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DatabaseService _databaseService=getIt.get<DatabaseService>();
  DashboardCubit(): super(const DashboardState());

  void loadDashboardData() async{
    emit(state.copyWith(isLoading: true));
    try {
      final totalSales = await _databaseService.getTotalSales();
      final totalCount = await _databaseService.getOrderCount();
      print(totalSales);
      emit(state.copyWith(
        totalSales: totalSales,
        totalCount: totalCount,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

}