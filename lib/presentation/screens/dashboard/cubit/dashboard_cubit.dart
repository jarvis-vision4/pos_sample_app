import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../data/services/database_service.dart';
import '../../../../locator/locator.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DatabaseService _service=getIt.get<DatabaseService>();
  DashboardCubit(): super(const DashboardState());

  void loadDashboardData() {
  }

}