import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/services/database_service.dart';
import '../../../../locator/locator.dart';
import 'order_list_state.dart';


class OrderListCubit extends Cubit<OrderListState>{
  final DatabaseService _databaseService=getIt.get();
  OrderListCubit():super(const OrderListState());
  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true));
    try {
      final orders = await _databaseService.getAllOrders();
      emit(state.copyWith(
        orders: orders,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}