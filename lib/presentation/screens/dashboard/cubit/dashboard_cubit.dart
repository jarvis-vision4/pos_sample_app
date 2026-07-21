import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_sample_app/data/services/database_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DatabaseService _service=GetIt.I.get<DatabaseService>();
  DashboardCubit(): super(const DashboardState());

  void loadDashboardData() {
  }

}