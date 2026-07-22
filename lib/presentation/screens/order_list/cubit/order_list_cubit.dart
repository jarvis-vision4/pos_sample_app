import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_list_state.dart';


class OrderListCubit extends Cubit<OrderListState>{
  OrderListCubit():super(const OrderListState());
}